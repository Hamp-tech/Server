//
//  APIBase.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 4/2/18.
//

import Foundation
import PerfectMongoDB
import PerfectHTTP

class APIBase: APIAble, Debugable {
    
    // MARK: - Properties
    var mongoDatabase: MongoDatabase
    var repositories: HampyRepositories?
    
    // MARK: - Init
    required init(mongoDatabase: MongoDatabase, repositories: HampyRepositories? = nil) {
        self.mongoDatabase = mongoDatabase
        self.repositories = repositories
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
