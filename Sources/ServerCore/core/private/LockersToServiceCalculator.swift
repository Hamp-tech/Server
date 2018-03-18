//
//  LockersToServiceCalculator.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 4/2/18.
//


struct LockersToServiceCalculator {
    
    // Cube
    private static let spaces: [Size: Int] = [
        .S: 1,
        .M: 2
    ]
    
	static func lockers(to services: [_HampyHiredService], point: HampyPoint) -> [HampyLocker] {
		
		var lockers: [HampyLocker] = []
		
		for s in services {
			for _ in 0..<s.amount {
				let locker = point.oneLocker(of: s.service.size!)
				guard let l = locker else { return [] }
				lockers.append(l)
			}
		}
		
		return lockers
    }
}
