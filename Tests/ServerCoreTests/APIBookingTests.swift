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
        let id = response.data?.identifier
        
        XCTAssertNotNil(id)
        
        response.data?.identifier = nil
        
        
        let bookingResult = HampyBooking(identifier: nil, userID: "de7d6f7733324fd69d52b562ddd7589f", basket: [HampyHiredService(service: "1", amount: 1)], price: "13", point: "1", pickUpTime: HampyBooking.PickUpTime.afternoon, deliveryLockers: [HampyLocker(identifier: "1", number: 1, code: 1111, available: false, capacity: .S)], pickUpLockers: nil)
        
        XCTAssertEqual(response.code, .ok)
        XCTAssertEqual(response.data!.json, bookingResult.json)
        
        _ = db.drop()
        client.close()
    }
    
    func testBooking_1Service_noLockersAvailable() {
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
    
        var points = repositories.pointsRepository.find(query: BSON())
        var p = points[0]
        
        p.lockers?.forEach {
            var o = $0
            o.available = false
            p.updateLocker(locker: o)
            repositories.pointsRepository.update(obj: p)
            
        }
        
        points = repositories.pointsRepository.find(query: BSON())
        p = points[0]
        p.lockers?.forEach {
            XCTAssertFalse($0.available!)
        }
        
        var response = booking.booking(data: data, userID: "de7d6f7733324fd69d52b562ddd7589f")
        
        XCTAssertEqual(response.code, .conflict)
        
        _ = db.drop()
        client.close()
    }
    
    func testBooking_2Service_allLockersAvailable() {
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
                    }, {
                        "service" : "2",
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
        let id = response.data?.identifier
        
        XCTAssertNotNil(id)
        
        response.data?.identifier = nil
        
        
        let bookingResult = HampyBooking(identifier: nil, userID: "de7d6f7733324fd69d52b562ddd7589f", basket: [HampyHiredService(service: "1", amount: 1), HampyHiredService(service: "2", amount: 1)], price: "13", point: "1", pickUpTime: HampyBooking.PickUpTime.afternoon, deliveryLockers: [HampyLocker(identifier: "1", number: 1, code: 1111, available: false, capacity: .S)], pickUpLockers: nil)
        
        XCTAssertEqual(response.code, .ok)
        XCTAssertEqual(response.data!.json, bookingResult.json)
        
        _ = db.drop()
        client.close()
    }
    
}
