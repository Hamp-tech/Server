//
//  APIUser.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import Foundation
import PerfectMongoDB

class APIUser: APIAble {
    
    // MARK: - Properties
    let mongoDatabase: MongoDatabase
    fileprivate var mongoCollection: MongoCollection?
    
    
    // MARK: - Init
    init(mongoClient: MongoDatabase) {
        self.mongoDatabase = mongoClient
        self.mongoCollection = mongoDatabase.getCollection(name: Schemes.Mongo.Collections.users)
    }
    
    // MARK: - APIAble
    func routes() -> Routes {
        var routes = Routes()
        routes.add(create())
        return routes
    }
}

private extension APIUser {
    func create() -> Route {
        return Route(method: .post, uri: Schemes.User.create, handler: {request, response in
            let data = request.postBodyString?.data(using: .utf8)
            var user = try? JSONDecoder().decode(HampyUser.self, from: data!)
            user?.lastActivity = Date().iso8601()
            user?.identifier = UUID.init().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
            
            var hampyResponse = HampyResponse<HampyUser>()

            if var u = user, let mc = self.mongoCollection {
                do {
                    let bson = try BSON.init(json: u.json)
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
                } catch let error {
                    print("APIUser - Bson init error => \(error)")
                }
            }
            response.setBody(json: hampyResponse.json)
            response.completed()
        })
    }
}
