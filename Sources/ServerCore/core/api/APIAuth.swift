//
//  APIAuth.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectHTTP
import PerfectMongoDB

class APIAuth: APIAble {
    
    // MARK: - Properties
    var mongoDatabase: MongoDatabase
    var repositories: HampyRepositories?
    
    // MARK: - Init
    required init(mongoDatabase: MongoDatabase, repositories: HampyRepositories? = nil) {
        self.mongoDatabase = mongoDatabase
        self.repositories = repositories
    }

    // MARK: - APIAble
    func routes() -> Routes {
        var routes = Routes()
        routes.add(signin())
        routes.add(signup())
        routes.add(restore())
        return routes
    }
}

private extension APIAuth {
    
    func signin() -> Route {
        return Route(method: .post, uri: Schemes.Auth.signin, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            
            guard let d = data else {
                Logger.d("Handler", event: .e)
                assert(false)
            }
            
            let hampyResponse = self.signin(body: d)
            
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    func signup() -> Route {
        return Route(method: .post, uri: Schemes.Auth.signup, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                Logger.d("Handler", event: .e)
                assert(false)
            }
            
            Logger.d("Sign un started")
            
            self.signup(body: d, completionBlock: { (resp) in
                response.setBody(string: resp.json)
                response.completed()
                
                Logger.d("Sign up finished")
            })
            
            
        })
    }
    
    func restore() -> Route {
        // TODO: implement
        return Route(method: .post, uri: Schemes.Auth.restore, handler: { (request, response) in
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.message = "TODO: IMPLEMENT"
            response.setBody(string: hampyResponse.json)
            response.completed()
            
        })
    }
}

internal extension APIAuth {
    
    func signin(body: Data) -> HampyResponse<HampyUser> {
        var hampyResponse: HampyResponse<HampyUser>!
        let user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: body)
        
        if let u = user {
            let result = self.repositories!.usersRepository.exists(obj: u)
            
            if result.0 {
                hampyResponse = APIHampyResponsesFactory.Auth.signinOK(user: result.1!)
            } else {
                hampyResponse = APIHampyResponsesFactory.Auth.signinFailNotFound()
            }
        } else {
            hampyResponse = APIHampyResponsesFactory.Auth.signinFailBadRequest()
        }
        
        return hampyResponse
    }
    
    func signup(body: Data, completionBlock:@escaping (HampyResponse<HampyUser>) -> ()) {
        var user = try! HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: body)
        user.lastActivity = Date().iso8601()
        user.identifier = UUID.generateHampIdentifier()
    
        var userToFind = HampyUser()
        userToFind.email = user.email
        let existsResult = self.repositories!.usersRepository.exists(obj: userToFind)
        
        if existsResult.0 {
            completionBlock(APIHampyResponsesFactory.Auth.signupFailConflict())
            Logger.d("User exists!")
        } else {
            Logger.d("Create costumer started")
            StripeGateway.createCustomer(userID: user.identifier!) { (stripeResponse) in
                switch stripeResponse.code {
                case .ok:
                    Logger.d("Create costumer finished")
                    Logger.d("Create user on database")
                    user.stripeID = stripeResponse.data!["id"] as? String
                    user.cards = []
                    let _ = self.repositories!.usersRepository.create(obj: user)
                    Logger.d("Create user on database finished")
                    
                    completionBlock(APIHampyResponsesFactory.Auth.signupOK(user: user))
                default:
                    completionBlock(APIHampyResponsesFactory.Auth.signupFailUnknown())
                    Logger.d("Create costumer error, look logs!", event: .e)
                }
            }
        }
    }
}
