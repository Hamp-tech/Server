//
//  HampyRepositable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectMongoDB

protocol HampyRepositable {
    associatedtype T
    
    var mongoDatabase: MongoDatabase { get }
    var mongoCollection: MongoCollection! { get }
    
    init(mongoDatabase: MongoDatabase)
    
    func find(query: BSON) -> [T]
    func exists(query: BSON) -> (exists: Bool, obj: T?)
    func create(obj: T) -> MongoResult
    func update(obj: T) -> MongoResult
}
