//
//  Schemes.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

internal struct Schemes {
    private static let baseURL = "/api/v1"
    private static let userURL = baseURL + "/users/{id}"
    private static let authURL = baseURL + "/auth"
    private static let bookingURL = userURL + "/booking/"
    private static let scriptsURL = baseURL + "/scripts"
    
    struct Users {
        static let users = Schemes.userURL
    }
    
    struct Booking {
        static let newBooking = Schemes.bookingURL
    }
    
    struct Scripts {
        static let createServices = Schemes.scriptsURL + "/services/create"
        static let createHampPoints = Schemes.scriptsURL + "/hamppoints/create"
    }
    
    struct Auth {
        static let signin = Schemes.authURL + "/signin"
        static let signup = Schemes.authURL + "/signup"
        static let restore = Schemes.authURL + "/restore/{id}"
    }
    
    struct Mongo {
        static let uri = "mongodb://localhost"
        
        struct Databases {
            static let production = "hamp"
            static let development = "hampdev"
        }
        
        struct Collections {
            static let users = "users"
            static let services = "services"
            static let points = "points"
        }
    }
    
    struct Security {
        static let gateway = "QfTjWnZr4u7x!A%D*G-JaNdRgUkXp2s5"
    }
}

