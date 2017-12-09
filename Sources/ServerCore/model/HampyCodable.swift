//
//  HampyCodable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import Foundation

protocol HampyCodable: Codable {
    var json: String { get }
}

extension HampyCodable {
    var json: String {
        do {
            try HampySingletons.sharedJSONEncoder.encode(self)
        } catch let error {
            print("\(error)")
        }
        return String(data: try! HampySingletons.sharedJSONEncoder.encode(self), encoding: .utf8) ?? ""
    }
}