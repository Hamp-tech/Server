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
    
    // MARK: - Private API
    public static func start() throws {
        
        defer {
            server.stop()
            client.close()
        }
        
        let stripe = APIStripe()
        let userAPI = APIUser(mongoClient: client.getDatabase(name: Schemes.Mongo.Databases.development))

        routes.add(stripe.routes())
        routes.add(userAPI.routes())
        
        server.addRoutes(routes)
        server.serverPort = 8181
        
        server.setRequestFilters([(APIKeyRequestFilter(), .high)])
        
        try server.start()
        
    }
}

