//
//  APIable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import PerfectMongoDB

protocol APIAble {
    associatedtype T
    
    var mongoDatabase: MongoDatabase { get }
    var repository: HampyRepository<T>? { get }
    
    init(mongoDatabase: MongoDatabase, repository: HampyRepository<T>?)
    
    func routes() -> Routes
}
