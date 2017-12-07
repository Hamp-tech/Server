//
//  HampyResponse.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import Foundation

enum HampyHTTPCode: UInt16, Codable {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalError = 500
}

struct HampyResponse: HampyResponsable {
    var code: HampyHTTPCode
    var message: String
    var data: String
    
    init(code: HampyHTTPCode, message: String = "", data: String = "") {
        self.code = code
        self.message = message
        self.data = data
    }
}
