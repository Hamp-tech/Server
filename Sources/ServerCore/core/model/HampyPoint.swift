//
//  HampyPoint.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

import Foundation

class HampyPoint: HampyDatabaseable {
    static var databaseScheme: String = Schemes.Mongo.Collections.points
    
    var identifier: String?
    var location: HampyLocation?
    var CP: String?
    var address: String?
    var city: String?
    var lockers: Array<HampyLocker>?
    var lastActivity: String?
    var created: String?

    init(identifier: String?,
         location: HampyLocation?,
         CP: String?,
         address: String?,
         city: String?,
         lockers: Array<HampyLocker>?,
         lastActivity: String? = nil,
         created: String? = nil) {
        self.identifier = identifier
        self.location = location
        self.CP = CP
        self.address = address
        self.city = city
        self.lockers = lockers
        self.lastActivity = lastActivity
        self.created = created
    }
	
	func freeLockers() -> [HampyLocker] {
		guard let ls = lockers else { return [] }
		return ls.filter(isLockerAvailable)
	}
	
	func oneLocker(of size: Size) -> HampyLocker? {
		let locker = lockers?.filter(isLockerAvailable).filter{$0.capacity == size}.first
		return locker
	}
	
	private func isLockerAvailable(locker: HampyLocker) -> Bool {
		return locker.available
	}
	
}
