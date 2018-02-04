//
//  FirebaseGateway.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 3/2/18.
//

import Foundation

struct FirebaseGateway: Firebaseable {
    
    static func sendNotification(token: String, params: Firebaseable.Params, completion: @escaping Firebaseable.FirebaseResponse) {
        completion(HampyResponse<Firebaseable.Params>(code: .ok))
    }
    
    static func sendNotification(type: OS, params: Firebaseable.Params, completion: @escaping Firebaseable.FirebaseResponse) {
        completion(HampyResponse<Firebaseable.Params>(code: .ok))
    }
    
}