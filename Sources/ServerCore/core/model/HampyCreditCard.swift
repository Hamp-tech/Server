//
//  HampyCreditCard.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 2/2/18.
//

import Foundation

class HampyCreditCard: HampyCodable, HampyModelResponseable {
    var id: String?
    var name: String?
    var number: String?
    var exp_month: UInt8?
    var exp_year: UInt8?
    var cvc: String?
	
	init(id: String?,
		 name: String?,
		 number: String?,
		 exp_month: UInt8?,
		 exp_year: UInt8?,
		 cvc: String?) {
		self.id = id
		self.name = name
		self.number = number
		self.exp_month = exp_month
		self.exp_year = exp_year
		self.cvc = cvc
	}
	
	func hidePropertiesToResponse() {
		id = nil
		name = nil
		exp_year = nil
		exp_month = nil
		cvc = nil
	}
}
