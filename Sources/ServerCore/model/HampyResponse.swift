//
//  HampyResponse.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import Foundation

enum HampyHTTPCode: Int, Codable {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalError = 500
    case unknown = -1
    
    init(code: Int) {
        self = HampyHTTPCode(rawValue: code) ?? .unknown
    }

}

struct HampyResponse<T>: HampyCodable where T: HampyCodable {
    var code: HampyHTTPCode
    var message: String
    var data: T? = nil
    
    init() {
        code = .unknown
        message = ""
//        data = nil
    }
    
    init(code: HampyHTTPCode, message: String = "", data: T? = nil) {
        self.code = code
        self.message = message
//        self.data = data
    }
}
