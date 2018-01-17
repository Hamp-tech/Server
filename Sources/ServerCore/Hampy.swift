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
    
    // MARK: - Private API
    public static func start() throws {
        
        let mongoDatabase = client.getDatabase(name: Schemes.Mongo.Databases.development)
        
        defer {
            server.stop()
            client.close()
            mongoDatabase.close()
        }
        
        usersRepository = HampyUsersRepository(mongoDatabase: mongoDatabase)
        
        let stripe = APIStripe(mongoDatabase: mongoDatabase)
        let userAPI = APIUser(mongoDatabase: mongoDatabase)
        let authAPI = APIAuth(mongoDatabase: mongoDatabase, repository: usersRepository)

//        routes.add(stripe.routes())
//        routes.add(userAPI.routes())
        routes.add(authAPI.routes())
        
        server.addRoutes(routes)
        server.serverPort = 8181
        
        server.setRequestFilters([(APIKeyRequestFilter(), .high)])
        
        try server.start()
        
    }
}

