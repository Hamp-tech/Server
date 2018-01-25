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
    var repository: HampyRepository<HampyUser>?
    
    required init(mongoDatabase: MongoDatabase, repository: HampyRepository<HampyUser>? = nil) {
        self.mongoDatabase = mongoDatabase
        self.repository = repository
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
                // TODO: Implement error handler
                assert(false)
            }
            
            let hampyResponse = self.signin(body: d)
            
            response.setBody(json: hampyResponse.json)
            response.completed()
        })
    }
    
    func signup() -> Route {
        return Route(method: .post, uri: Schemes.Auth.signup, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                // TODO: Implement error handler
                assert(false)
            }
            
            let hampyResponse = self.signup(body: d)
            
            response.setBody(json: hampyResponse.json)
            response.completed()
        })
    }
    
    func restore() -> Route {
        // TODO: implement
        return Route(method: .post, uri: Schemes.Auth.restore, handler: { (request, response) in
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.message = "TODO: IMPLEMENT"
            response.setBody(json: hampyResponse.json)
            response.completed()
            
        })
    }
}

internal extension APIAuth {
    
    func signin(body: Data) -> HampyResponse<HampyUser> {
        var hampyResponse: HampyResponse<HampyUser>!
        let user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: body)
        
        if let u = user {
            let result = self.repository!.exists(obj: u)
            
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
    
    func signup(body: Data) -> HampyResponse<HampyUser> {
        var user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: body)
        user?.lastActivity = Date().iso8601()
        user?.identifier = UUID.generateHampIdentifier()
        
        var hampyResponse: HampyResponse<HampyUser>!
        
        if let u = user {
            var userToFind = HampyUser()
            userToFind.email = u.email
            let existsResult = self.repository!.exists(obj: userToFind)
            
            if existsResult.0 {
                hampyResponse = APIHampyResponsesFactory.Auth.signupFailConflict()
            } else {
                let result = self.repository!.create(obj: u)
                switch result {
                case .success:
                    hampyResponse = APIHampyResponsesFactory.Auth.signupOK(user: u)
                default:
                    hampyResponse = APIHampyResponsesFactory.Auth.signupFailUnknown()
                    break
                }
            }
        }
        
        return hampyResponse
    }
}
