//
//  HampyTransaction.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 28/1/18.
//

import Foundation

struct HampyTransaction: HampyDatabaseable {
    
    // MARK: - Properties
    static var databaseScheme: String = Schemes.Mongo.Collections.transactions
    var identifier: String?
    
    
}
