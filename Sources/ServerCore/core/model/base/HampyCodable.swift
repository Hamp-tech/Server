//
//  HampyCodable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 7/12/17.
//

import Foundation

protocol HampyCodable: Codable {
    var json: String { get }
    var dict: [String: Any] { get }
}

extension HampyCodable {
    var json: String {
        return String(data: try! HampySingletons.sharedJSONEncoder.encode(self), encoding: .utf8) ?? ""
    }
    
    var dict: [String: Any] {
        var d = [String:Any]()
        for (key, value) in Mirror(reflecting: self).children where key != nil {
            if case Optional<Any>.some(_) = value {
                
                #if os(Linux)
					d[key!] = value as! AnyObject
                #else
                    d[key!] = value as AnyObject
                #endif
            }
        }
        
        return d
    }
}


extension Array: HampyCodable {
    
}
