//
//  HampyRepository.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectMongoDB

internal class HampyRepository<T>: HampyRepositable where T: HampyDatabaseable {
    var mongoDatabase: MongoDatabase
    var mongoCollection: MongoCollection!
    
    required init(mongoDatabase: MongoDatabase) {
        guard type(of: self) != HampyRepository.self else {
             fatalError("HampyRepository instances can not be created")
        }
        self.mongoDatabase = mongoDatabase
        self.mongoCollection = self.mongoDatabase.getCollection(name: T.databaseScheme)
    }

    func find(query: BSON) -> [T] {
        let result = self.mongoCollection.find(query: query)
        var arr = Array<T>()
        result?.forEach{
            Logger.d($0.asString)
            let data = $0.asString.data(using: .utf8)!
            arr.append(try! HampySingletons.sharedJSONDecoder.decode(T.self, from: data))
        }
        
        return arr
    }
    
    func find(properties: Dictionary<String, Any>) -> [T] {
        let bson = BSON(map: properties)
        return find(query: bson)
    }
    
    func find(elements by: Array<Dictionary<String, Any>>) -> [T] {
        let arr = by.flatMap{
            find(properties: $0)
        }
        
        return arr
    }
    
     func exists(query: BSON) -> (exists: Bool, obj: T?) {
        let arr = find(query: query)
        let exists = arr.count > 0
        return (exists, exists ? arr[0] : nil)
    }
    
     func exists(obj: T) -> (exists: Bool, obj: T?) {
        let bson: BSON
        do {
            bson = try BSON(json: obj.json)
        } catch {
            return (false, nil)
        }
        
        return exists(query: bson)
    }
    
    // PRE: Assuming that obj has correct properties setted
     func create(obj: T) -> MongoResult {
        let bson = try! BSON(json: obj.json)
        return mongoCollection.save(document: bson)
    }
    
     func update(obj: T) -> MongoResult{
        guard let id = obj.identifier else { return MongoResult.error(0, 0, "")}
        let old = BSON()
        old.append(key: "identifier", string: id)
        
        let new = BSON()
        new.append(key: "$set", document: try! BSON(json: obj.json))
        return mongoCollection.update(selector: old, update: new)
    }
    
    func close() {
        mongoCollection.close()
    }
}
