//
//  _HampyHiredService.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 19/3/18.
//

import Foundation

class _HampyHiredService {
	var amount: Int
	var service: HampyService
	
	init(amount: Int, service: HampyService) {
		self.amount = amount
		self.service = service
	}
}
