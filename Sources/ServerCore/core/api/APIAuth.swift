//
//  APIAuth.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectHTTP
import PerfectMongoDB


class APIAuth: APIBase {
    
    // MARK: - APIAble
    override func routes() -> Routes {
        var routes = Routes()
        routes.add(signin())
        routes.add(signup())
        routes.add(restore())
        return routes
    }
}

private extension APIAuth {
    
    func signin() -> Route {
        return Route(method: .post, uri: Schemes.URLs.Auth.signin, handler: { (request, response) in
            self.debug()
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler error", event: .e)
                assert(false)
                return
            }
            
            self.debug("Started")
            let hampyResponse = self.signin(body: d)
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    func signup() -> Route {
        return Route(method: .post, uri: Schemes.URLs.Auth.signup, handler: { (request, response) in
            self.debug()
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler", event: .e)
                assert(false)
                return
            }
            
            self.debug("Started")
            
            self.signup(body: d, completionBlock: { (resp) in
                response.setBody(string: resp.json)
                response.completed()
                
                self.debug(resp.json)
                self.debug("Finished", event: resp.code == .ok ? .d : .e)
            })
            
            
        })
    }
    
    func restore() -> Route {
        // TODO: implement
        return Route(method: .post, uri: Schemes.URLs.Auth.restore, handler: { (request, response) in
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.message = "TODO: IMPLEMENT"
            response.setBody(string: hampyResponse.json)
            response.completed()
            
        })
    }
}

extension APIAuth {
    
    func signin(body: Data) -> HampyResponse<HampyUser> {
        var hampyResponse: HampyResponse<HampyUser>!
        let user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: body)
        
        if let u = user {
            let result = self.repositories!.usersRepository.exists(obj: u)
            
            if result.0 {
                self.debug("User exist")
                hampyResponse = APIHampyResponsesFactory.Auth.signinOK(user: result.1!)
            } else {
                self.debug("User doesn't exist")
                hampyResponse = APIHampyResponsesFactory.Auth.signinFailNotFound()
            }
        } else {
            self.debug("Bad request")
            hampyResponse = APIHampyResponsesFactory.Auth.signinFailBadRequest()
        }
        
        return hampyResponse
    }
    
    func signup(body: Data, completionBlock:@escaping (HampyResponse<String>) -> ()) {
        var user = try! HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: body)
        user.lastActivity = Date().iso8601()
        user.identifier = UUID.generateHampIdentifier()

        var userToFind = HampyUser()
        userToFind.email = user.email
        let existsResult = self.repositories!.usersRepository.exists(obj: userToFind)

        if existsResult.0 {
//            completionBlock(APIHampyResponsesFactory.Auth.signupFailConflict())
            self.debug("User exists!")
        } else {
            Logger.d("Create costumer started")
            StripeGateway.createCustomer(userID: user.identifier!) { (stripeResponse) in
                switch stripeResponse.code {
                case .ok:
                    self.debug("Create costumer finished")
                    self.debug("Create user on database")
                    user.stripeID = stripeResponse.data!["id"] as? String
                    user.cards = []
                    let result = self.repositories!.usersRepository.create(obj: user)
                    var r = HampyResponse<String>()
                    
                    switch result {
                    case .success:
                        break
                    case .error(_, _,let error):
                        r.data = error
                    case .replyDoc(_):
                        break
                    case .replyInt(_):
                        break
                    case .replyCollection(_):
                        break
                    }
                    self.debug("Create user on database finished")

                    completionBlock(r)
                default:
//                    completionBlock(APIHampyResponsesFactory.Auth.signupFailUnknown())
                    self.debug("Create costumer error, look logs!", event: .e)
                }
            }
        }
    }
}
