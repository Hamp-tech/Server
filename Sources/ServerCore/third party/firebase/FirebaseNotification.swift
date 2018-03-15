//
//  FirebaseNotification.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 11/3/18.
//

import Foundation

class FirebaseNotification: HampyDatabaseable, HampyModelResponseable {

    // MARK: - Properties
    static var databaseScheme: String = Schemes.Mongo.Collections.pushNotifications
    var identifier: String?
    var lastActivity: String?
    var created: String?
    var message: FirebaseNotificationMessage!
    
    // MARK: - Life cycle
    init(identifier: String? = nil,
         lastActivity: String? = nil,
         created: String? = nil,
         message: FirebaseNotificationMessage) {
        self.identifier = identifier
        self.lastActivity = lastActivity
        self.created = created
        self.message = message
    }
    
    func hidePropertiesToResponse() {
        identifier = nil
        lastActivity = nil
        created = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case lastActivity
        case created
        case message = ""
    }
}
