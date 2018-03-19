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
		
		var sum = services.reduce(0, acum)
		var lockersToReturn = [HampyLocker]()
		
		for s in services {
			for _ in 0..<s.amount {
				let locker = point.oneLocker()
				guard let l = locker else { return [] }
				l.available = false
				lockersToReturn.append(l)
				sum -= spaces[s.service.size!]!
			}
		}

		return lockersToReturn
    }
	
	private static func acum(last: Int, service: _HampyHiredService) -> Int {
		return last + (spaces[service.service.size!]! * Int(service.amount))
	}
}
