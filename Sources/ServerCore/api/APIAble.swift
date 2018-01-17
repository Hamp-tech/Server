//
//  APIable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import PerfectMongoDB

protocol APIAble {
    
    var mongoDatabase: MongoDatabase { get }
    var mongoCollection: MongoCollection? { get }
    
    init(mongoDatabase: MongoDatabase)
    
    func routes() -> Routes
}
