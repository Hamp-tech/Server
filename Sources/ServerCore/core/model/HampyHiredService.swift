//
//  HampyHiredService.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

class HampyHiredService: HampyCodable {
    var service: String? // Service identifier
    var amount: Int?
	
	init(service: String?,
		 amount: Int?) {
		self.service = service
		self.amount = amount
	}
}
