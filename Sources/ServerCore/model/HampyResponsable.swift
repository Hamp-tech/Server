//
//  HampyResponsable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import Foundation

protocol HampyResponsable: Codable {
    var json: String { get }
}

extension HampyResponsable {
    var json: String {
        return String(data: try! HampySingletons.sharedJSONEncoder.encode(self), encoding: .utf8) ?? ""
    }
}
