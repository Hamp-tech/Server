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

        routes.add(method: .get, uri: "/", handler: {
            request, response in
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            response.completed()
        }
        )
        
        // Add the routes to the server.
        server.addRoutes(routes)
        
        // Set a listen port of 8181
        server.serverPort = 8181
        
        try server.start()
    }
}

