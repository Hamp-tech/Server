//
//  HampyDatabaseable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation

protocol HampyDatabaseable: HampyCodable {
    var identifier: String? { get set }
}
