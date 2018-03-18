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
    
    static func lockers(to services: [HampyService], point: HampyPoint) -> [HampyLocker] {
//		var sum = services.reduce(0, acum)
//
//		let lockers = point.freeLockers()
//		guard lockers.count > 0 else { return lockers }
//
//		var lockersToReturn = [HampyLocker]()
//
//		var i = 0
//		while sum >= 0 {
//			let locker = lockers[i]
//			sum -= spaces[locker.capacity!]!
//			lockersToReturn.append(locker)
//			i += 1
//		}
		
        return [point.lockers![0]]
    }
	
	static func lockers(to services: [HampyHiredService], point: HampyPoint) -> [HampyLocker]? {
		
		
		return nil
	}
	
	private static func acum(last: Int, service: HampyService) -> Int {
		return last + spaces[service.size!]!
	}
}
