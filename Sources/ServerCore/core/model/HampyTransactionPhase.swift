//
//  HampyTransactionPhase.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 7/2/18.
//

import Foundation

enum Phase: Int, Codable {
    case toPickUp
    case washing
    case drying
    case folding
    case toDeliver
    case delivering
    case delivered
}

class HampyTransactionPhase: HampyCodable {
    var employeeId: String?
    var phase : Phase
    var date: String = {
        return Date().iso8601()
    }()
}
