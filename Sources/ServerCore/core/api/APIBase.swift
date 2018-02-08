//
//  APIBase.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 4/2/18.
//

import Foundation
import PerfectMongoDB
import PerfectHTTP
import MongoKitten

class APIBase: APIAble, Debugable {
    
    // MARK: - Properties
    var mongoDatabase: MongoDatabase
    var repositories: HampyRepositories?
    var database: Database
    
    // MARK: - Init
    required init(database: Database, mongoDatabase: MongoDatabase, repositories: HampyRepositories? = nil) {
        self.mongoDatabase = mongoDatabase
        self.repositories = repositories
        self.database = database
    }
    
    func routes() -> Routes {
        return Routes()
    }
    
    
    func debug(_ message: Any = "",
               event: Logger.Event = .d,
               fileName: String = #file,
               line: Int = #line,
               column: Int = #column,
               function: String = #function) {
        
        Logger.d(message, event: event, fileName: fileName, line: line, column: column, function: function)
        
    }
}
