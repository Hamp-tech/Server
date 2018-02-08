//
//  Hampy.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMongoDB
import MongoKitten

public final class Hampy {
    
    // MARK: - Properties
    private static var server = HTTPServer()
    private static var routes = Routes()
    private static let client = try! MongoClient(uri: Schemes.Mongo.uri)
    private static var environtment: HampyEnvirontment = .development
    private static var repositories: HampyRepositories!
    private static var database = try! MongoKitten.Database("mongodb://localhost/hampdev")
    
    // MARK: - Private API
    public static func start() throws {
        
        let mongoDatabase = client.getDatabase(name: environtment.databaseName)
    
        defer {
            server.stop()
            client.close()
            mongoDatabase.close()
        }

        repositories = HampyRepositories(database: database, mongoDatabase: mongoDatabase)
        
        let userAPI = APIUser(database: database, mongoDatabase: mongoDatabase, repositories: repositories)
        let authAPI = APIAuth(database: database, mongoDatabase: mongoDatabase, repositories: repositories)
        let transactionsAPI = APITransactions(database: database, mongoDatabase: mongoDatabase, repositories: repositories)
        let pointsAPI = APIPoints(database: database, mongoDatabase: mongoDatabase, repositories: repositories)

        routes.add(userAPI.routes())
        routes.add(authAPI.routes())
        routes.add(transactionsAPI.routes())
        routes.add(pointsAPI.routes())
        
        
        server.addRoutes(routes)
        server.serverPort = 8181
        
        if environtment != HampyEnvirontment.development {
            server.setRequestFilters([(APIKeyRequestFilter(), .high)])
        } else {
            let scriptsAPI = APIScripts(database: database, mongoDatabase: mongoDatabase)
            server.addRoutes(scriptsAPI.routes())
        }
        
        try server.start()
        
    }
}

