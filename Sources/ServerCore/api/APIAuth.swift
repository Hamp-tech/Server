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
            var hampyResponse = HampyResponse<HampyUser>()
            let user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: d)
        
            if let u = user {
                do {
                    let bson = try BSON(json: u.json)
                    let result = self.repository!.exists(query: bson)
                
                    if result.0 {
                        hampyResponse.code = .ok
                        hampyResponse.data = result.1
                    } else {
                        hampyResponse.code = .notFound
                        hampyResponse.message = "User doesn't exists"
                    }
                } catch {
                    hampyResponse.code = .unknown
                }
                
                response.setBody(json: hampyResponse.json)
                response.completed()
            } else {
                hampyResponse.code = .notFound
                hampyResponse.message = "User doesn't exists"
            }
        })
    }
    
    func signup() -> Route {
        return Route(method: .post, uri: Schemes.Auth.signup, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                // TODO: Implement error handler
                assert(false)
            }
            
            var user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: d)
            user?.lastActivity = Date().iso8601()
            user?.identifier = UUID.init().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
            
            var hampyResponse = HampyResponse<HampyUser>()
            
            if var u = user {
                do {
                    var userToFind = HampyUser()
                    userToFind.email = u.email
                    userToFind.password = u.password
                    
                    let bson = try BSON(json: userToFind.json)
                    
                    let repResult = self.repository!.exists(query: bson)
                    
                    if repResult.0 {
                        hampyResponse.code = .conflict
                        hampyResponse.message = "User already exists"
                    } else {

                        let result = self.repository!.create(obj: u)
                        switch result {
                        case .success:
                        // TODO: Change it to remove response
                            u.password = nil
                            u.lastActivity = nil
                            u.language = nil
                            u.tokenFCM = nil
                        // TODO: --
                            hampyResponse.code = .created
                            hampyResponse.message = "User created"
                        default:
                            hampyResponse.code = .unknown
                        }
                    }
                } catch let error {
                    print("APIUser - Bson init error => \(error)")
                    hampyResponse.code = .unknown
                }
            }
            response.setBody(json: hampyResponse.json)
            response.completed()
            
        })
    }
}
