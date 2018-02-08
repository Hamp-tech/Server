//
//  APIable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import MongoKitten

protocol APIAble {
    var repositories: HampyRepositories? { get }
    var database: Database { get }

    init(database: Database, repositories: HampyRepositories?)
    
    func routes() -> Routes
}
