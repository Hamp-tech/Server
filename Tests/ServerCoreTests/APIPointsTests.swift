//
//  APIPointsTests.swift
//  ServerCoreTests
//
//  Created by Joan Molinas Ramon on 5/2/18.
//

import XCTest
@testable import ServerCore
import PerfectMongoDB

class APIPointsTests: XCTestCase {
    
    let client = try! MongoClient(uri: "mongodb://localhost")
    
    func testResetLocker() {
        
        let db = client.getDatabase(name: "testPoints")
        let repositories = HampyRepositories(mongoDatabase: db)
        let points = APIPoints(mongoDatabase: db, repositories: repositories)
        HampyScripts.createHampPoints(database: db)
        
        defer {
            repositories.close()
            db.close()
        }
        
        let response = points.resetLocker(pid: "1", lid: "1")
        
        XCTAssertEqual(response.code, .ok)
        
        db.drop()
    }
   
}
