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
        for r in result! {
            let data = r.asString.data(using: .utf8)!
            arr.append(try! HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: data))
        }
        
        return arr
    }
    
    override func exists(query: BSON) -> (exits: Bool, obj: HampyUser?) {
        let arr = find(query: query)
        let exists = arr.count > 0
        return (exists, exists ? arr[0] : nil)
    }
    
    override func create(obj: HampyUser) -> MongoResult {
        let bson = try! BSON(json: obj.json)
        return mongoCollection.save(document: bson)
    }
}


