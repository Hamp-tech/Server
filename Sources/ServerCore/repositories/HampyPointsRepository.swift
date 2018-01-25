//
//  HampyPointsRepository.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation
import PerfectMongoDB

class HampyPointsRepository: HampyRepository<HampyPoint> {
    typealias T = HampyPoint
    
    required init(mongoDatabase: MongoDatabase) {
        super.init(mongoDatabase: mongoDatabase)
        super.mongoCollection = mongoDatabase.getCollection(name: Schemes.Mongo.Collections.points)!
    }
    
    override func find(query: BSON) -> [T] {
        let result = self.mongoCollection.find(query: query)
        var arr = Array<HampyPoint>()
        result?.forEach{
            let data = $0.asString.data(using: .utf8)!
            arr.append(try! HampySingletons.sharedJSONDecoder.decode(T.self, from: data))
        }
        
        return arr
    }
    
    override func exists(query: BSON) -> (exists: Bool, obj: T?) {
        let arr = find(query: query)
        let exists = arr.count > 0
        return (exists, exists ? arr[0] : nil)
    }
    
    override func exists(obj: T) -> (exists: Bool, obj: T?) {
        let bson: BSON
        do {
            bson = try BSON(json: obj.json)
        } catch {
            return (false, nil)
        }
        
        return exists(query: bson)
    }
    
    // PRE: Assuming that obj has correct properties setted
    override func create(obj: T) -> MongoResult {
        let bson = try! BSON(json: obj.json)
        return mongoCollection.save(document: bson)
    }
    
    override func update(obj: T) -> MongoResult{
        guard let id = obj.identifier else { return MongoResult.error(0, 0, "")}
        let old = BSON()
        old.append(key: "identifier", string: id)
        
        let new = BSON()
        new.append(key: "$set", document: try! BSON(json: obj.json))
        return mongoCollection.update(selector: old, update: new)
    }
}
