//
//  APIBooking.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

import Foundation
import PerfectHTTP
import PerfectMongoDB

class APIBooking: APIAble {
    
    typealias T = HampyUser
    
    // MARK: - Properties
    var mongoDatabase: MongoDatabase
    var repository: HampyRepository<HampyUser>?
    
    required init(mongoDatabase: MongoDatabase, repository: HampyRepository<T>? = nil) {
        self.mongoDatabase = mongoDatabase
        self.repository = repository
    }
    
    // MARK: - APIAble
    func routes() -> Routes {
        var routes = Routes()
        routes.add(newBooking())
        return routes
    }
}

private extension APIBooking {
    func newBooking() -> Route {
        return Route(method: .post, uri: Schemes.Booking.newBooking, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                assert(false)
            }
        
            do {
                var order = try HampySingletons.sharedJSONDecoder.decode(HampyBooking.self, from: d)
                order.userID = request.urlVariables["id"]
                print(order)
                
                // Request available locker
            } catch let error {
                print(error)
            }
            
            
            response.setBody(json: "{}")
            response.completed()
        })
    }
}
