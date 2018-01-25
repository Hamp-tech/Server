//
//  HampyPoint.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

struct HampyPoint: HampyDatabaseable {
    var identifier: String?
    var location: HampyLocation?
    var CP: String?
    var address: String?
    var city: String?
    var lockers: Array<HampyLocker>?
    
    init(identifier: String?,
         location: HampyLocation?,
         CP: String?,
         address: String?,
         city: String?,
         lockers: Array<HampyLocker>?) {
        self.identifier = identifier
        self.location = location
        self.CP = CP
        self.address = address
        self.city = city
        self.lockers = lockers
    }
}
