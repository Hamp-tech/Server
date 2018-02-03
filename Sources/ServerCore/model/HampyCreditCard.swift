//
//  HampyCreditCard.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 2/2/18.
//

import Foundation

struct HampyCreditCard: HampyCodable {
    var id: String?
    var number: String?
    var exp_month: UInt8?
    var exp_year: UInt8?
    var cvc: String?
}
