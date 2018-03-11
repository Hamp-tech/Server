//
//  HampyHiredService.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

class HampyHiredService: HampyCodable {
    var service: String? // Service identifier
    var amount: UInt8?
	
	init(service: String?,
		 amount: UInt8?) {
		self.service = service
		self.amount = amount
	}
}
