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
    

}


