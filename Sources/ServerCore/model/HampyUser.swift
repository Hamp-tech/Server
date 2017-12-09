//
//  HampyUser.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

struct HampyUser: HampyCodable {
    var identifier: String?
    var name: String?
    var surname: String?
    var mail: String?
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
    
    //TODO: Validate properties
}
