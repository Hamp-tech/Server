//
//  FirebaseNotificationMessage.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 11/3/18.
//

import Foundation

class FirebaseNotificationMessage: HampyCodable {
    
    // MARK: - Properties
    var token: String?
	var body: FirebaseNotificationMessageBody?
    
    // MARK: - Properties
    init(token: String?,
         body: FirebaseNotificationMessageBody?) {
        self.token = token
		self.body = body
    }
}
