//
//  HampyBooking.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 23/1/18.
//

import Foundation

struct HampyBooking: HampyDatabaseable {
    
    static var databaseScheme: String = Schemes.Mongo.Collections.bookings
    
    enum PickUpTime: String, HampyCodable {
        case morning = "0"
        case afternoon = "1"
    }
    
    var identifier: String?
    var userID: String?
    var basket: Array<HampyHiredService>?
    var price: String?
    var point: String? // Identifier to location
    var pickUpTime: PickUpTime?
    var deliveryLocker: HampyLocker?
    var pickUpLocker: HampyLocker?
}
