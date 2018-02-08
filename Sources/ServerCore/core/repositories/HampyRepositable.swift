//
//  HampyRepositable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 17/1/18.
//

import Foundation
import PerfectMongoDB
import MongoKitten

protocol HampyRepositable {
    associatedtype T
    
    var mongoDatabase: MongoDatabase { get }
    var mongoCollection: PerfectMongoDB.MongoCollection! { get }
    
    var database: Database { get }
    
    init(database: Database, mongoDatabase: MongoDatabase)
    
    func find(doc: Document) -> [T]
    func find(properties: Dictionary<String, Any?>) -> [T]
    func find(elements by: Array<Dictionary<String, Any>>) -> [T]
    func exists(doc: Document) -> (exists: Bool, obj: T?)
    func exists(obj: T) -> (exists: Bool, obj: T?)
    func create(obj: T) throws -> T
    func update(obj: T) throws -> T
    func close()
}
