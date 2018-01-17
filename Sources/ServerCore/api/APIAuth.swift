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
    var mongoCollection: MongoCollection?
    
    required init(mongoDatabase: MongoDatabase) {
        self.mongoDatabase = mongoDatabase
        self.mongoCollection = mongoDatabase.getCollection(name: Schemes.Mongo.Collections.users)
    }

    // MARK: - APIAble
    func routes() -> Routes {
        var routes = Routes()
        routes.add(signin())
        routes.add(signup())
        return routes
    }
    
    deinit {
        mongoCollection?.close()
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
            var user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: d)
            
            if let u = user, let mc = self.mongoCollection {
                do {
                    let bson = try BSON(json: u.json)
                    let result = mc.find(query: bson)
                    var arr = Array<Data>()
                    for i in result!{
                        arr.append(i.asString.data(using: .utf8)!)
                    }
                    
                    if arr.count > 0 {
                        user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: arr[0])
                        hampyResponse.code = .ok
                        hampyResponse.data = user
                    } else {
                        hampyResponse.code = .notFound
                        hampyResponse.message = "User doesn't exists"
                    }
                } catch {
                    hampyResponse.code = .unknown
                }
                
                response.setBody(json: hampyResponse.json)
                response.completed()
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
            if var u = user, let mc = self.mongoCollection {
                do {
                    let bson = try BSON(json: u.json)
                    let result = mc.save(document: bson)
                    
                    switch result {
                    case .success:
                        
                        // TODO: Move to another model
                        u.password = nil
                        u.lastActivity = nil
                        u.language = nil
                        u.tokenFCM = nil
                        u.os = nil
                        // End TODO
                        
                        hampyResponse.code = .created
                        hampyResponse.data = u
                    default:
                        hampyResponse.code = .unknown
                    }
                    bson.close()
                } catch let error {
                    print("APIUser - Bson init error => \(error)")
                }
            }
            response.setBody(json: hampyResponse.json)
            response.completed()
            
        })
    }
}
