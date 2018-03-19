//
//  HampyBooking.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 23/1/18.
//

import Foundation

class HampyBooking: HampyDatabaseable, HampyModelResponseable {
    static var databaseScheme: String = Schemes.Mongo.Collections.bookings
    
    enum PickUpTime: String, HampyCodable {
        case morning = "0"
        case afternoon = "1"
    }
    
    var identifier: String?
    var userID: String?
    var basket: [HampyHiredService]?
    var price: Float?
    var pickUpTime: PickUpTime?
    var deliveryLockers: [HampyLocker]?
    var pickUpLockers: [HampyLocker]?
    var lastActivity: String?
    var created: String?
	var point: HampyPoint?
	
	init(identifier: String?,
		 userID: String?,
		 basket: [HampyHiredService]?,
		 price: Float?,
		 pickUpTime: PickUpTime?,
		 deliveryLockers: [HampyLocker]?,
		 pickUpLockers: [HampyLocker]?,
		 lastActivity: String?,
		 created: String?,
		 point: HampyPoint?
		) {
		self.identifier = identifier
		self.userID = userID
		self.basket = basket
		self.price = price
		self.pickUpTime = pickUpTime
		self.deliveryLockers = deliveryLockers
		self.pickUpLockers = pickUpLockers
		self.lastActivity = lastActivity
		self.created = created
		self.point = point
	}
	
	func hidePropertiesToResponse() {
		point?.lockers = nil
	}
}
