//
//  HampyEnvirontment.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 22/1/18.
//

import Foundation

struct HampyEnvirontment {
    
    // MARK: - Environtments
    public static let development = HampyEnvirontment(databaseName: Schemes.Mongo.Databases.development)
    public static let production = HampyEnvirontment(databaseName: Schemes.Mongo.Databases.production)
    
    // MARK: - Properties
    public private(set) var databaseName: String
    
}

extension HampyEnvirontment: Equatable {
    static func ==(lhs: HampyEnvirontment, rhs: HampyEnvirontment) -> Bool {
        return lhs.databaseName == rhs.databaseName
    }
    
    
}
