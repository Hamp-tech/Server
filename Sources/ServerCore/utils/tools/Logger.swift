//
//  Logger.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 31/1/18.
//

import Foundation

struct Logger {
    static func d(_ message: Any,
                    event: Event = .d,
                    fileName: String = #file,
                    line: Int = #line,
                    column: Int = #column,
                    function: String = #function,
                    inAnExternalFile: Bool = true) {
        let log = "\(event.rawValue)[\(Date().iso8601())] \(sourceFileName(filePath: fileName)).\(function):\(line) => \(message)"
        print(log)
        
        if inAnExternalFile {
			
        }
    }
}

extension Logger {
    enum Event: String{
        case e = "[‼️]" // error
        case i = "[ℹ️]" // info
        case d = "[💬]" // debug
        case v = "[🔬]" // verbose
        case w = "[⚠️]" // warning
        case s = "[🔥]" // severe
    }
}

private extension Logger {
    static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : (components.last?.components(separatedBy: ".").first!)!
    }
}
