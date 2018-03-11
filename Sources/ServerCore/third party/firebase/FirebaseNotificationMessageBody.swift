//
//  FirebaseNotificationMessageBody.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 11/3/18.
//

import Foundation

class FirebaseNotificationMessageBody: HampyCodable {
	
	// MARK: - Properties
	var title: String?
	var body: String?
	
	// MARK: - Life cycle
	init(title: String, body: String) {
		self.title = title
		self.body = body
	}
}
