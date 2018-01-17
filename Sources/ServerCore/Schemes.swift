//
//  Schemes.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

internal struct Schemes {
    private static let baseURL = "/api/v1"
    private static let userURL = baseURL + "/{id}"
    private static let authURL = baseURL
    
    struct User {
//        internal static let createCostumer = Schemes.userURL + "/costumer"
        static let signup = Schemes.userURL
    }
    
    struct Auth {
        static let signin = Schemes.authURL + "/signin"
        static let signup = Schemes.authURL + "/signup"
    }
    
    struct Mongo {
        static let uri = "mongodb://localhost"
        
        struct Databases {
            static let production = "hamp"
            static let development = "hampdev"
        }
        
        struct Collections {
            static let users = "users"
        }
    }
    
    struct Security {
        static let gateway = "QfTjWnZr4u7x!A%D*G-JaNdRgUkXp2s5"
    }
}

