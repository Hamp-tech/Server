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
            let user = try? JSONDecoder().decode(HampyUser.self, from: data!)
            var hampyResponse = HampyResponse<HampyUser>()
            
            if let u = user, let mc = self.mongoCollection {
                let bson = try! BSON.init(json: u.json)
                let res = mc.save(document: bson)
                print(res)
                hampyResponse.code = .ok
                hampyResponse.data = u
                response.setBody(json: hampyResponse.json)
            }
            
            
            response.completed()
        })
    }
}
