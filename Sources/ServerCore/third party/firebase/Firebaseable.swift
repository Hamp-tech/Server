//
//  Firebaseable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 3/2/18.
//

import Foundation

enum OS {
    case ios
    case android
}

protocol Firebaseable {
    typealias Params = [String: Any]
    typealias FirebaseResponse = (HampyResponse<Params>) -> ()
    
    static func sendNotification(token: String, params: Params, completion: @escaping FirebaseResponse)
    
    static func sendNotification(type: OS, params: Params, completion: @escaping FirebaseResponse)
}
