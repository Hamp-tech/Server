//
//  HampyUsersRepository.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectMongoDB

class HampyUsersRepository: HampyRepository<HampyUser>{
    typealias T = HampyUser
    
    required init(mongoDatabase: MongoDatabase) {
        super.init(mongoDatabase: mongoDatabase)
        super.mongoCollection = mongoDatabase.getCollection(name: Schemes.Mongo.Collections.users)!
    }
    
    override func find(query: BSON) -> [HampyUser] {
        let result = self.mongoCollection.find(query: query)
        var arr = Array<HampyUser>()
        result?.forEach{
            let data = $0.asString.data(using: .utf8)!
            arr.append(try! HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: data))
        }
        
        return arr
    }
    
    override func exists(query: BSON) -> (exists: Bool, obj: HampyUser?) {
        let arr = find(query: query)
        let exists = arr.count > 0
        return (exists, exists ? arr[0] : nil)
    }
    
    override func exists(obj: HampyUser) -> (exists: Bool, obj: HampyUser?) {
        let bson: BSON
        do {
           bson = try BSON(json: obj.json)
        } catch {
            return (false, nil)
        }
        
        return exists(query: bson)
    }
    
    // PRE: Assuming that obj has correct properties setted
    override func create(obj: HampyUser) -> MongoResult {
        let bson = try! BSON(json: obj.json)
        return mongoCollection.save(document: bson)
    }
    
    override func update(obj: HampyUser) -> MongoResult{
        guard let id = obj.identifier else { return MongoResult.error(0, 0, "")}
        let old = BSON()
        old.append(key: "identifier", string: id)
        
        let new = BSON()
        new.append(key: "$set", document: try! BSON(json: obj.json))
        return mongoCollection.update(selector: old, update: new)
    }
    
    override func close() {
        mongoCollection.close()
    }
}


