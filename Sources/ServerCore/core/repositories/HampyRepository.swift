//
//  HampyRepository.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectMongoDB
import MongoKitten


extension Dictionary where Key == String  {
    var kittenDictionary: [(String, Primitive?)] {
//        var dict = [(String, Primitive?)]()
//
//        forEach{dict.append(($0.key, $0.value as? Primitive))}
        
        return map{($0.key, $0.value as? Primitive)}
    }
}

class HampyRepository<T>: HampyRepositable where T: HampyDatabaseable {
    var mongoDatabase: MongoDatabase
    var mongoCollection: PerfectMongoDB.MongoCollection!
    var database: Database
    var collection: MongoKitten.MongoCollection!
    
    required init(database: Database, mongoDatabase: MongoDatabase) {
        guard type(of: self) != HampyRepository.self else {
             fatalError("HampyRepository instances can not be created")
        }
        self.mongoDatabase = mongoDatabase
        self.mongoCollection = self.mongoDatabase.getCollection(name: T.databaseScheme)
        self.database = database
        self.collection = database[T.databaseScheme]
        print(collection)
    }

    func aux(doc: Document) throws -> T {
      return try HampySingletons.sharedJSONDecoder.decode(T.self, from: Data.init(bytes: doc.makeExtendedJSONData()))
    }
    //
    func find(query: BSON) -> [T] {
        let result = self.mongoCollection.find(query: query)
        var arr = Array<T>()
        result?.forEach{
            let data = $0.asString.data(using: .utf8)!
            
            do {
                let o = try HampySingletons.sharedJSONDecoder.decode(T.self, from: data)
                _ = update(obj: o) // To update date
                arr.append(o)
            } catch let error{
                Logger.d(error.localizedDescription, event: .e)
            }
        }
        
        
        return arr
    }
    //
    //
    func find(properties: Dictionary<String, Any>) -> [T] {
        let bson = BSON(map: properties)
        return find(query: bson)
    }
    //
    
    func find(doc: Document) -> [T] {
        let query = Query(doc)
        
        var arr = [T]()
        do {
            let docs = try collection.find(query)
            arr = try docs.map {try aux(doc: $0)}
        } catch let error {
            Logger.d(error.localizedDescription, event: .e)
        }
        
        return arr
    }
    
    func find1(properties: Dictionary<String, Any?>) -> [T] {
        let doc = Document(dictionaryElements: properties.kittenDictionary)
        return find(doc: doc)
    }
    
    func find(elements by: Array<Dictionary<String, Any>>) -> [T] {
        return by.flatMap {find1(properties: $0)}
    }
    
    //
    func exists(query: BSON) -> (exists: Bool, obj: T?) {
        let arr = find(query: query)
        let exists = arr.count > 0
        return (exists, exists ? arr[0] : nil)
    }
    //
    
    func exists(doc: Document) -> (exists: Bool, obj: T?) {
        let query = Query(doc)
        var result: Document? = nil
        var obj: T? = nil
    
        do {
            result = try collection.findOne(query)
            if let res = result {
                obj = try aux(doc: res)
            }
        } catch let error {
            Logger.d(error.localizedDescription, event: .e)
        }
        
        return (result != nil, obj)
    }
    
     func exists(obj: T) -> (exists: Bool, obj: T?) {
        let doc = Document(obj.json.data(using: .utf8)!)!
        return exists(doc: doc)
    }
    
    // PRE: Assuming that obj has correct properties setted
     func create(obj: T) -> MongoResult {
        let d = Date().iso8601()
        var o = obj
        o.lastActivity = d
        o.created = d
        
        let bson = try! BSON(json: o.json)
        
        return mongoCollection.save(document: bson)
    }
    
    func create1(obj: T) throws -> T {
        let d = Date().iso8601()
        var o = obj
        o.lastActivity = d
        o.created = d
        

        
        let doc = Document(obj.json.data(using: .utf8)!)!
        try collection.append(doc)
        do {
            try collection.insert(doc)
        } catch let error {
            Logger.d(error.localizedDescription, event: .e)
        }
        
        return obj
    }
    
    func update1(obj: T) throws -> T {
        let doc = Document(obj.json.data(using: .utf8)!)!
        try collection.update(to: doc)
        
        return obj
    }
    
     func update(obj: T) -> MongoResult{
        guard let id = obj.identifier else { return MongoResult.error(0, 0, "")}
        
        var o = obj
        o.lastActivity = Date().iso8601()
        
        let old = BSON()
        old.append(key: "identifier", string: id)
        
        let new = BSON()
        new.append(key: "$set", document: try! BSON(json: o.json))
        return mongoCollection.update(selector: old, update: new)
    }
    
    func close() {
        mongoCollection.close()
    }
}
