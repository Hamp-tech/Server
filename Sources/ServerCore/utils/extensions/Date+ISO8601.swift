//
//  NSDate+ISO8601.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 16/1/18.
//

import Foundation


extension Date {
    private static let iso8601Formatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    func iso8601() -> String {
        return Date.iso8601Formatter.string(from: self)
    }
}
