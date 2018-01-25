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

public final class Hampy {
    
    // MARK: - Properties
    private static var server = HTTPServer()
    private static var routes = Routes()
    private static let client = try! MongoClient(uri: Schemes.Mongo.uri)
    private static var usersRepository: HampyUsersRepository!
    private static var environtment: HampyEnvirontment = .development
    
    // MARK: - Private API
    public static func start() throws {
        
        let mongoDatabase = client.getDatabase(name: environtment.databaseName)
    
        defer {
            server.stop()
            client.close()
            mongoDatabase.close()
        }

        usersRepository = HampyUsersRepository(mongoDatabase: mongoDatabase)
        
        let userAPI = APIUser(mongoDatabase: mongoDatabase, repository: usersRepository)
        let authAPI = APIAuth(mongoDatabase: mongoDatabase, repository: usersRepository)
        let bookingAPI = APIBooking(mongoDatabase: mongoDatabase)

        routes.add(userAPI.routes())
        routes.add(authAPI.routes())
        routes.add(bookingAPI.routes())
        
        
        server.addRoutes(routes)
        server.serverPort = 8181
        
        if environtment != HampyEnvirontment.development {
            server.setRequestFilters([(APIKeyRequestFilter(), .high)])
        } else {
            let scriptsAPI = APIScripts(mongoDatabase: mongoDatabase)
            server.addRoutes(scriptsAPI.routes())
        }
        
        try server.start()
        
    }
}

