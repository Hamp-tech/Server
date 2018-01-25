//
//  HampyScripts.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 22/1/18.
//

import Foundation
import PerfectMongoDB


struct HampyScripts {
    static func createServices(database: MongoDatabase) {
        let s1 = HampyService(identifier: "1", name: "Small bag", description: "Description small bag", imageURL: "", price: 13.0, size: .S, active: true)
        let s2 = HampyService(identifier: "1", name: "Big bag", description: "Description big bag", imageURL: "", price: 15.0, size: .S, active: true)
        
        let arr = [s1, s2]
        let collection = database.getCollection(name: "services")
        _ = collection?.drop()
        
        arr.forEach {
            let encoder = try! HampySingletons.sharedJSONEncoder.encode($0)
            let s = String.init(data: encoder, encoding: .utf8)
            let bson = try! BSON(json: s!)
            _ = collection?.save(document: bson)
        }
    }
    
    static func createHampPoints(database: MongoDatabase) {
        let vLockers = [HampyLocker(identifier: 1, number: 1, code: 1111, available: true, capacity: .S),
                        HampyLocker(identifier: 2, number: 2, code: 1112, available: true, capacity: .S),
                        HampyLocker(identifier: 3, number: 3, code: 1113, available: true, capacity: .M)]
        let vendrell = HampyPoint(identifier: "1", location: HampyLocation(name: "1", latitude: 0, longitude: 0), CP: "43700", address: "C/ foo bar 1", city: "El Vendrell", lockers: vLockers)
        
        
        let collection = database.getCollection(name: "points")
        _ = collection?.drop()
        
        let bson = try! BSON(json: vendrell.json)
        _ = collection?.save(document: bson)
        
    }
}
