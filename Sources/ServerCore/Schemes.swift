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
    private static let bookingURL = userURL + "/booking"
    private static let scriptsURL = baseURL + "/scripts"
    private static let transactionsURL = userURL + "/transactions"
    private static let stripeURL = "https://api.stripe.com/v1"
    
    struct Users {
        static let base = Schemes.userURL
        static let newCard = Schemes.Users.base + "/cards"
        static let removeCard = Schemes.Users.base + "/cards/{id}"
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
    
    struct URLs {
        static let transactions = Schemes.transactionsURL
        static let transactionsID = Schemes.transactionsURL + "/{tid}"
        static let transactionsDeliver = Schemes.transactionsURL + "/{tid}/deliver"
        
        struct Stripe {
            static let createCustomer = Schemes.stripeURL + "/customers"
            static let createCard = Schemes.stripeURL + "/customers/{id}/sources"
            static let pay = Schemes.stripeURL + "/charges"
        }
    }
    
    struct Mongo {
        static let uri = "mongodb://localhost"
        
        struct Databases {
            static let production = "hamp"
            static let development = "hampdev"
        }
        
        struct Collections {
            static let `default` = ""
            static let users = "users"
            static let services = "services"
            static let points = "points"
            static let bookings = "bookings"
            static let transactions = "transactions"
        }
    }
    
    struct Security {
        static let gateway = "QfTjWnZr4u7x!A%D*G-JaNdRgUkXp2s5"
    }
}

