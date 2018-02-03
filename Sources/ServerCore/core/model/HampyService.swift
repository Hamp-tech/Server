//
//  HampyService.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

struct HampyService: HampyDatabaseable {
    static var databaseScheme: String = Schemes.Mongo.Collections.services
    
    var identifier: String?
    var name: String?
    var description: String?
    var imageURL: String?
    var price: Float?
    var size: Size?
    var active: Bool?
    var lastActivity: String?
    var created: String?
    
    init(identifier: String?,
         name: String?,
         description: String?,
         imageURL: String?,
         price: Float?,
         size: Size?,
         active: Bool?,
         lastActivity: String? = nil,
         created: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.size = size
        self.active = active
        self.lastActivity = lastActivity
        self.created = created
    }
}
