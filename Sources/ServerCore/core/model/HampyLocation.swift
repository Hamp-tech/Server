//
//  HampyLocation.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

class HampyLocation: HampyCodable {
    var name: String?
    var latitude: Double?
    var longitude: Double?
	
	init(name: String?,
		 latitude: Double?,
		 longitude: Double?) {
		self.name = name
		self.latitude = latitude
		self.longitude = longitude
	}
}
