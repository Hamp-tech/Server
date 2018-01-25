//
//  HampyLocker.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

struct HampyLocker: HampyCodable {
    var identifier: Int?
    var number: Int?
    var code: Int?
    var available: Bool?
    var capacity: Size?
}
