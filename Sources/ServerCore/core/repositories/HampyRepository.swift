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
        do {
            Logger.d(doc.makeExtendedJSONString())
            try HampySingletons.sharedJSONDecoder.decode(T.self, from: Data.init(bytes: doc.makeExtendedJSONData()))
        } catch {
            print(error.localizedDescription)
        }
      return try HampySingletons.sharedJSONDecoder.decode(T.self, from: Data.init(bytes: doc.makeExtendedJSONData()))
    }
    
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
    
    func find(properties: Dictionary<String, Any?>) -> [T] {
        let doc = Document(dictionaryElements: properties.kittenDictionary)
        return find(doc: doc)
    }
    
    func find(elements by: Array<Dictionary<String, Any>>) -> [T] {
        return by.flatMap {find(properties: $0)}
    }
    
    
    func exists(doc: Document) -> (exists: Bool, obj: T?) {
        let query = Query(doc)
        var result: Document? = nil
        var obj: T? = nil
    
        do {
            result = try collection.findOne(query)
            if let res = result {
                obj = try aux(doc: res)
            }
        } catch let error as MongoError {
            Logger.d(error.debugDescription, event: .e)
        } catch let error {
            Logger.d(error.localizedDescription, event: .e)
        }
        
        return (result != nil, obj)
    }
    
     func exists(obj: T) -> (exists: Bool, obj: T?) {
        let doc = try! Document.init(extendedJSON: obj.json)
        guard let d = doc else {
            return (false, nil)
        }
        return exists(doc: d)
    }
    
    func create(obj: T) throws -> T {
        let d = Date().iso8601()
        var o = obj
        o.lastActivity = d
        o.created = d
        
        let doc = try Document.init(extendedJSON: o.json)
        try collection.insert(doc!)
        
        return obj
    }
    
    func update(obj: T) throws -> T {
        
        let query = Query(aqt: AQT.contains(key: "identifier", val: obj.identifier!, options: NSRegularExpression.Options.allowCommentsAndWhitespace))
        let doc = try Document(extendedJSON: obj.json)!
        
        try collection.update(query, to: ["$set": doc], upserting: true)
        
        return obj
    }
    
    func close() {
        mongoCollection.close()
    }
}
