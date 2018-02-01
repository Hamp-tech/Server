//
//  HampyPoint.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

import Foundation

struct HampyPoint: HampyDatabaseable {
    
    static var databaseScheme: String = Schemes.Mongo.Collections.points
    
    var identifier: String?
    var location: HampyLocation?
    var CP: String?
    var address: String?
    var city: String?
    var lockers: Array<HampyLocker>?


    func freeLockers(with capacity: Size) -> Array<HampyLocker>? {
        guard let lock = lockers else { return nil }
        
        return lock.filter{$0.available!}.filter{$0.capacity == capacity}
    }
    
    mutating func updateLocker(locker: HampyLocker) {
        let idx = lockers?.index{$0.identifier == locker.identifier}
        guard idx != NSNotFound else { return }
        self.lockers?[idx!] = locker
    }
    
    func findLockers(numbersOfLocker: Array<Int>) -> Array<HampyLocker> {
        return lockers!.filter{numbersOfLocker.contains($0.number!)}
    }
}
