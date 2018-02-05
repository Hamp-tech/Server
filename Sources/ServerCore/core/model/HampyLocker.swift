//
//  HampyLocker.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

struct HampyLocker: HampyCodable {
    
    var identifier: String?
    var number: Int?
    var code: String?
    var available: Bool?
    var capacity: Size?
    
    init(identifier: String?, number: Int?, code: String?, available: Bool?, capacity: Size?) {
        self.identifier = identifier
        self.number = number
        self.code = code
        self.available = available
        self.capacity = capacity
    }
    
//    init(original: HampyLocker) {
//        self.identifier = original.identifier
//        self.number = original.number
//        self.code = original.code
//        self.available = original.available
//        self.capacity = original.capacity
//    }
}
