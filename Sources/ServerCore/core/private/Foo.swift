//
//  Foo.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 4/2/18.
//


struct Foo {
    
    // Cube
    private static let spaces: [Size: Int] = [
        .S: 1,
        .M: 2
    ]
    
    static func lockers(to services: [HampyService], point: HampyPoint) -> [HampyLocker]? {
        let freeLockers = point.freeLockers(with: .S)
//        let sizes = services.map{$0.size!}
        
        return freeLockers != nil ? [freeLockers!.first!] : nil
    }
}
