//
//  APIable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import PerfectMongoDB
import MongoKitten

protocol APIAble {    
    var mongoDatabase: MongoDatabase { get }
    var repositories: HampyRepositories? { get }
    var database: Database { get }

    init(database: Database, mongoDatabase: MongoDatabase, repositories: HampyRepositories?)
    
    func routes() -> Routes
}
