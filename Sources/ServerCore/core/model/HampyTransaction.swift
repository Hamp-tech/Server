//
//  HampyTransaction.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 28/1/18.
//

import Foundation

class HampyTransaction: HampyDatabaseable, HampyModelResponseable {

    // To be able to use 2 phase commits
    enum DBState: String, Codable {
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
    var pickUpDate: String?
    var deliveryDate: String?
//    var dbState: DBState?
//    var phases: [HampyTransactionPhase]?
    var lastActivity: String?
    var created: String?
	var creditCard: HampyCreditCard?
	
	// MARK: - Life cycle
	
	// TODO: Create init
	func hidePropertiesToResponse() {
		lastActivity = nil
		booking?.hidePropertiesToResponse()
		creditCard?.hidePropertiesToResponse()
		
	}
}
