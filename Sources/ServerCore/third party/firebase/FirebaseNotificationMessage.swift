//
//  FirebaseNotificationMessage.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 11/3/18.
//

import Foundation

class FirebaseNotificationMessage: HampyCodable {
    
    enum Priority: String, Codable {
        case high = "high"
        case normal = "normal"
    }
    
    // MARK: - Properties
    var token: String
	var body: FirebaseNotificationMessageBody
    var priority: Priority
    
    // MARK: - Properties
    init(token: String,
         body: FirebaseNotificationMessageBody,
         priority: Priority = .high) {
        self.token = token
		self.body = body
        self.priority = priority
    }
    
    enum CodingKeys: String, CodingKey {
        case token = "to"
        case body = "notification"
        case priority
    }
}
