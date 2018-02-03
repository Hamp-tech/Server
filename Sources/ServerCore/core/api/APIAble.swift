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
    var repositories: HampyRepositories? { get }

    init(mongoDatabase: MongoDatabase, repositories: HampyRepositories?)
    
    func routes() -> Routes
}
