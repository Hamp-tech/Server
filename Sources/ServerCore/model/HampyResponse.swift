//
//  HampyResponse.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

enum HampyHTTPCode: Int, Codable {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
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
        code = .badRequest
        message = ""
    }
    
    init(code: HampyHTTPCode, message: String = "", data: T? = nil) {
        self.code = code
        self.message = message
    }
}
