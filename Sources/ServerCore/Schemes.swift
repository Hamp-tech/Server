//
//  Schemes.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

struct Schemes {
    private static let baseURL = "/api/v1"
    private static let userURL = baseURL + "/users/{id}"
    private static let authURL = baseURL + "/auth"
    private static let bookingURL = userURL + "/booking"
    private static let scriptsURL = baseURL + "/scripts"
    private static let transactionsURL = userURL + "/transactions"
    private static let stripeURL = "https://api.stripe.com/v1"
    private static let pointsURL = baseURL + "/points/{pid}"
    
    struct URLs {
        struct Auth {
            static let signin = Schemes.authURL + "/signin"
            static let signup = Schemes.authURL + "/signup"
            static let restore = Schemes.authURL + "/restore/{id}"
        }
        
        struct Users {
            static let base = Schemes.userURL
            static let newCard = Schemes.URLs.Users.base + "/cards"
            static let removeCard = Schemes.URLs.Users.base + "/cards/{cid}"
        }
        
        struct Stripe {
            static let customers = Schemes.stripeURL + "/customers"
            static let cards = Schemes.stripeURL + "/customers/{id}/sources"
            static let removeCard = Schemes.URLs.Stripe.cards + "/{cid}"
            static let pay = Schemes.stripeURL + "/charges"
        }
        
        struct Points {
            static let reset = Schemes.pointsURL + "/{lid}/reset"
        }
        
        struct Transactions {
            static let transactions = Schemes.transactionsURL
            static let transactionsID = Schemes.transactionsURL + "/{tid}"
            static let transactionsDeliver = Schemes.transactionsURL + "/{tid}/deliver"
        }
        
        struct Scripts {
            static let createServices = Schemes.scriptsURL + "/services/create"
            static let createHampPoints = Schemes.scriptsURL + "/hamppoints/create"
            static let sendTestMail = Schemes.scriptsURL + "/testMail"
        }
    }
    
    struct Mongo {
        static let productionURL = "mongodb://hamp:HampCluster18@cluster0-shard-00-00-rf4vj.mongodb.net:27017,cluster0-shard-00-01-rf4vj.mongodb.net:27017,cluster0-shard-00-02-rf4vj.mongodb.net:27017/hampdev?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin"
        static let developmentURL = "mongodb://localhost/hampdev"
        
        struct Databases {
            static let production = "hampdev"
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

