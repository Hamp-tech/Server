//
//  HampyTransaction.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 28/1/18.
//

import Foundation

struct HampyTransaction: HampyDatabaseable {
    // To be able to use 2 phase commits
    enum DBState: String, Codable {
        case initial
        case accepted
        case paying
        case done
        case canceled
    }
    
    enum Phase: Int, Codable {
        case toPickUp
        case washing
        case drying
        case folding
        case toDeliver
        case delivering
        case delivered
    }
    
    // MARK: - Properties
    static var databaseScheme: String = Schemes.Mongo.Collections.transactions
    var identifier: String?
    var userID: String?
    var booking: HampyBooking?
    var creditCardIdentifier: String?
    var pickUpDate: String?
    var deliveryDate: String?
    var dbState: DBState?
    var phase: Phase?
    
    
}
