//
//  Schemes.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

internal struct Schemes {
    private static let baseURL = "/api/v1"
    private static let userURL = baseURL + "/{id}"
    
    struct User {
//        internal static let createCostumer = Schemes.userURL + "/costumer"
        static let create = Schemes.userURL
    }
    
    struct Mongo {
        static let uri = "mongodb://localhost"
        
        struct Databases {
            static let production = "hamp-prod"
            static let development = "hamp-dev"
        }
        
        struct Collections {
            static let users = "users"
        }
    }
}

