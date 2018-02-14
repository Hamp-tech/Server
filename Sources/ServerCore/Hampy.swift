//
//  Hampy.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import MongoKitten

public final class Hampy {
    
    // MARK: - Properties
    private static var server = HTTPServer()
    private static var routes = Routes()
    private static var environtment: HampyEnvirontment!
    private static var repositories: HampyRepositories!
    private static var database: Database!
    
    // MARK: - Private API
    public static func start() throws {
        
        defer {
            server.stop()
        }
    
        #if DEBUG
            environtment = .development
        #else
            environtment = .development
        #endif
        
        Logger.d("Running on \(environtment.databaseName) database", event: .i)
        
        database = try! MongoKitten.Database(environtment.databaseURL)
        
        repositories = HampyRepositories(database: database)
        
        let userAPI = APIUser(database: database, repositories: repositories)
        let authAPI = APIAuth(database: database, repositories: repositories)
        let transactionsAPI = APITransactions(database: database, repositories: repositories)
        let pointsAPI = APIPoints(database: database, repositories: repositories)

        routes.add(userAPI.routes())
        routes.add(authAPI.routes())
        routes.add(transactionsAPI.routes())
        routes.add(pointsAPI.routes())
        
        
        server.addRoutes(routes)
        server.serverPort = 8181
        
        if environtment != HampyEnvirontment.development {
            server.setRequestFilters([(APIKeyRequestFilter(), .high)])
        } else {
            let scriptsAPI = APIScripts(database: database)
            server.addRoutes(scriptsAPI.routes())
        }
        
        try server.start()
        
    }
}

