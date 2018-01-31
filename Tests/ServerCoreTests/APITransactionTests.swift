//
//  APITransactionTests.swift
//  ServerCoreTests
//
//  Created by Joan Molinas Ramon on 31/1/18.
//

import XCTest
@testable import ServerCore
import PerfectMongoDB

class APITransactionTests: XCTestCase {
    
    let client = try! MongoClient(uri: "mongodb://localhost")
    
    func testTransaction_1Services_lockersAvailable() {
        let db = client.getDatabase(name: "testTransactions")
        let repositories = HampyRepositories(mongoDatabase: db)
        let transaction = APITransactions(mongoDatabase: db, repositories: repositories)
        HampyScripts.createServices(database: db)
        HampyScripts.createHampPoints(database: db)
        
        defer {
            repositories.close()
            db.close()
        }
        
        let json = """
            {
                "creditCardIdentifier" : "1234",
                "booking": {
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
            }
        """
        
        let data = json.data(using: .utf8)!
        transaction.newTransaction(data: data, userID: "de7d6f7733324fd69d52b562ddd7589f") { (response) in
            XCTAssertNotNil(response.data?.identifier)
            
            let jsonResult = """
                {
                    "pickUpDate": "2018-01-31T11:49:58.899",
                    "userID": "f40de5d7ba4246598ad41daef45ac7e5",
                    "identifier": "090cd5b1009c4f84b778bb047ea4397a",
                    "creditCardIdentifier": "1234",
                    "booking": {
                        "pickUpLockers": [
                            {
                                "code": 1111,
                                "number": 1,
                                "identifier": "1",
                                "available": true,
                                "capacity": "S"
                            }
                        ],
                        "pickUpTime": "1",
                        "basket": [
                            {
                                "service": "1",
                                "amount": 1
                            }
                        ],
                        "price": "13",
                        "point": "1"
                    }
                }
            """
            let data = jsonResult.data(using: .utf8)!
            var resp = try! HampySingletons.sharedJSONDecoder.decode(HampyTransaction.self, from: data)
            
            XCTAssertNotNil(resp.identifier)
            resp.identifier = nil
            
            XCTAssertNotNil(resp.pickUpDate)
            resp.pickUpDate = nil
            
            XCTAssertNil(resp.booking?.deliveryLockers)
            XCTAssertNotNil(resp.booking?.pickUpLockers)
            
            let dl = resp.booking!.pickUpLockers![0]
            let l = HampyLocker(identifier: "1", number: 1, code: 1111, available: true, capacity: .S)
            
            XCTAssertEqual(dl.json, l.json)
            
            _ = db.drop()
            client.close()
        }
        
    }
}
