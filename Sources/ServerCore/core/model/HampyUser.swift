//
//  HampyUser.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

struct HampyUser: HampyDatabaseable, HampyModelResponseable {
	
    static var databaseScheme: String = Schemes.Mongo.Collections.users
    
    var identifier: String?
    var name: String?
    var surname: String?
    var email: String?
    var password: String?
    var phone: String?
    var birthday: String?
    var gender: String?
    var signupDate: String?
    var tokenFCM: String?
    var os: String?
    var language: String?
    var lastActivity: String?
    var unsubscribed: Bool?
    var stripeID: String?
    var cards: [HampyCreditCard]?
    var created: String? = nil
	
	mutating func hidePropertiesToResponse() {
		self.password = nil
		self.lastActivity = nil
		self.language = nil
		self.tokenFCM = nil
		self.os = nil
		self.stripeID = nil
	}

    //TODO: Validate properties
}
