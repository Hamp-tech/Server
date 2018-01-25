//
//  APIBookingTests.swift
//  ServerCoreTests
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import XCTest
@testable import ServerCore
import PerfectMongoDB

class APIBookingTests: XCTestCase {

    let client = try! MongoClient(uri: "mongodb://localhost")
    
    func testBooking_1Service_allLockersAvailable() {
        let db = client.getDatabase(name: "testBooking")
        let repositories = HampyRepositories(mongoDatabase: db)
        let booking = APIBooking(mongoDatabase: db, repositories: repositories)
        HampyScripts.createServices(database: db)
        HampyScripts.createHampPoints(database: db)
        
        defer {
            repositories.close()
            db.close()
        }
        
        let json = """
            {
                "basket": [
                    {
                        "service" : "1",
                        "amount" : 1
                    }
            ],
                "price": "13",
                "point": "1",
                "pickUpTime": "1"
            }
        """
        
        let data = json.data(using: .utf8)!
        var response = booking.booking(data: data, userID: "de7d6f7733324fd69d52b562ddd7589f")
        response.data?.identifier = nil
        
        
        let bookingResult = HampyBooking(identifier: nil, userID: "de7d6f7733324fd69d52b562ddd7589f", basket: [HampyHiredService(service: "1", amount: 1)], price: "13", point: "1", pickUpTime: HampyBooking.PickUpTime.afternoon, deliveryLocker: HampyLocker(identifier: "1", number: 1, code: 1111, available: false, capacity: .S), pickUpLocker: nil)
        
        XCTAssertEqual(response.code, .ok)
        XCTAssertEqual(response.data!.json, bookingResult.json)
        
        _ = db.drop()
        client.close()
        
    }
    
}
