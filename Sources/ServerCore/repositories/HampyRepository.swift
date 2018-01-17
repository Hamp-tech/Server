//
//  HampyRepository.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectMongoDB

class HampyRepository<T>: HampyRepositable {
    var mongoDatabase: MongoDatabase
    var mongoCollection: MongoCollection!
    
    required init(mongoDatabase: MongoDatabase) {
        guard type(of: self) != HampyRepository.self else {
             fatalError("HampyRepository instances can not be created")
        }
        self.mongoDatabase = mongoDatabase
    }
    
    func find(query: BSON) -> [T] {
        fatalError("Must override")
    }
    
    func exists(query: BSON) -> (exists: Bool, obj: T?) {
        fatalError("Must override")
    }
    
    func create(obj: T) -> MongoResult {
        fatalError("Must override")
    }
}