//
//  APIScripts.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 22/1/18.
//

import Foundation
import PerfectHTTP

class APIScripts: APIBase {
    
    // MARK: - APIAble
    override func routes() -> Routes {
        var routes = Routes()
        routes.add(createServices())
        routes.add(createHampPoints())
        routes.add(sendTestMail())
        return routes
    }
}

private extension APIScripts {
    
    // PRE: Is needed an existing user
    func createServices() -> Route {
        return Route(method: .post, uri: Schemes.URLs.Scripts.createServices, handler: { (request, response) in
            HampyScripts.createServices(database: self.database)
            response.appendBody(string: "{ \"status\": \"OK\" }")
            response.completed()
        })
    }
    
    func createHampPoints() -> Route {
        return Route(method: .post, uri: Schemes.URLs.Scripts.createHampPoints, handler: { (request, response) in
            HampyScripts.createHampPoints(database: self.database)
            response.appendBody(string: "{ \"status\": \"OK\" }")
            response.completed()
        })
    }
    
    func sendTestMail() -> Route {
        return Route(method: .post, uri: Schemes.URLs.Scripts.sendTestMail, handler: { (request, response) in
            HampyScripts.sendTemplateMail()
            response.appendBody(string: "{ \"status\": \"OK\" }")
            response.completed()
        })
    }
}
