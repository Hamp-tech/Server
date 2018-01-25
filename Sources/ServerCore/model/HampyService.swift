//
//  HampyService.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

struct HampyService: HampyDatabaseable {
    var identifier: String?
    var name: String?
    var description: String?
    var imageURL: String?
    var price: Float?
    var size: Size?
    var active: Bool?
}
