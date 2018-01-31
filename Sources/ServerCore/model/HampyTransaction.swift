//
//  HampyTransaction.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 28/1/18.
//

import Foundation

struct HampyTransaction: HampyDatabaseable {
    // To be able to use 2 phase commits
    enum State: String, Codable {
        case initial
        case accepted
        case paying
        case done
        case canceled
    }
    
    // MARK: - Properties
    static var databaseScheme: String = Schemes.Mongo.Collections.transactions
    var identifier: String?
    var userID: String?
    var booking: HampyBooking?
    var creditCardIdentifier: String?
    var pickUpDate: String?
    var deliveryDate: String?
    var state: State?
    
    
}
