//
//  Hampy.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

public final class Hampy {
    
    // MARK: - Properties
    private static var server = HTTPServer()
    private static var routes = Routes()
    
    // MARK: - Private API
    public static func start() throws {
        
        let stripe = APIStripe()

        routes.add(stripe.routes())
        server.addRoutes(routes)
        server.serverPort = 8181
        
        try server.start()
    }
}

