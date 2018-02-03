//
//  UUID+UniqueID.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation

extension UUID {
    static func generateHampIdentifier() -> String {
        return UUID.init().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
    }
}
