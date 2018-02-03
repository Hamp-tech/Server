//
//  HampyDatabaseable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation

protocol HampyDatabaseable: HampyCodable {
    static var databaseScheme: String { get }
    var identifier: String? { get set }
    var lastActivity: String? { get set }
    var created: String? { get set }
}
