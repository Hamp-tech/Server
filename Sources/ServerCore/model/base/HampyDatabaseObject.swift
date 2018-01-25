//
//  HampyDatabaseObject.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation

class HampyDatabaseObject: HampyDatabaseable {
    static var databaseScheme: String = Schemes.Mongo.Collections.`default`
    var identifier: String?
}
