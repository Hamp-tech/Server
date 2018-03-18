import XCTest
@testable import ServerCore
import MongoKitten

class APIAuthTests: XCTestCase {
	
	let client = try! MongoKitten.Database("mongodb://localhost/testAuth")
    
    // RUN TESTS FROM TOP TO BOTTOM
    
    func testSignup_newUser() {
		
        let repositories = HampyRepositories(database: client)
        
//        let auth = APIAuth(mongoDatabase: db, repositories: repositories)
//
//        defer {
//            repositories.close()
//            db.close()
//        }
//
//        let randomNum = arc4random_uniform(100000)
//        //let email = "\(randomNum)@gmail.com"
//
//        let json = """
//            {
//                "name" : "Joannnn",
//                "surname" : "Molinas",
//                "email" : "joanmramon@gmail.com",
//                "password" : "1234567890",
//                "phone" : "646548142",
//                "gender" : "M",
//                "tokenFCM" : "tokeeeeen",
//                "os" : "ios",
//                "language" : "esES"
//            }
//        """
//
//        let data = json.data(using: .utf8)!
//
//        let singupExpectation = expectation(description: "Sign up ok expectation")
//
//        auth.signup(body: data) { (response) in
//            XCTAssertEqual(response.code, .created)
//            singupExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 10) { (error) in
//            if let error = error {
//                Logger.d(error.localizedDescription, event: .e)
//            }
//        }
		
    }
    
//    func testSignup_existentUser() {
//        let db = client.getDatabase(name: "testAuth")
//        let repositories = HampyRepositories(mongoDatabase: db)
//        
//        defer {
//            repositories.close()
//            db.close()
//        }
//        
//        let auth = APIAuth(mongoDatabase: db, repositories: repositories)
//        
//        let json = """
//            {
//                "name" : "Joannnn",
//                "surname" : "Molinas",
//                "email" : "joanmramon@gmail.com",
//                "password" : "1234567890",
//                "phone" : "646548142",
//                "gender" : "M",
//                "tokenFCM" : "tokeeeeen",
//                "os" : "ios",
//                "language" : "esES"
//            }
//        """
//        
//        let data = json.data(using: .utf8)!
//        let singupExpectation = expectation(description: "Sign up expectation")
//        
//        auth.signup(body: data) { (response) in
//            XCTAssertEqual(response.code, .conflict)
//            singupExpectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 10) { (error) in
//            if let error = error {
//                Logger.d(error.localizedDescription, event: .e)
//            }
//        }
//        
//    }
//    
//    func testSignin_existentCredentials() {
//        let db = client.getDatabase(name: "testAuth")
//        let repositories = HampyRepositories(mongoDatabase: db)
//        
//        defer {
//            repositories.close()
//            db.close()
//        }
//        
//        let auth = APIAuth(mongoDatabase: db, repositories: repositories)
//        let json = """
//            {
//                "email" : "joanmramon@gmail.com",
//                "password" : "1234567890"
//            }
//        """
//        
//        let data = json.data(using: .utf8)!
//        let response = auth.signin(body: data)
//        
//        XCTAssertEqual(response.code, .ok)
//    }
//    
//    func testSignin_badCredentials_email() {
//        let db = client.getDatabase(name: "testAuth")
//        let repositories = HampyRepositories(mongoDatabase: db)
//        
//        defer {
//            repositories.close()
//            db.close()
//        }
//        
//        let auth = APIAuth(mongoDatabase: db, repositories: repositories)
//        
//        let json = """
//            {
//                "email" : "joanmramon1@gmail.com",
//                "password" : "1234567890"
//            }
//        """
//        
//        let data = json.data(using: .utf8)!
//        let response = auth.signin(body: data)
//        
//        XCTAssertEqual(response.code, .notFound)
//    }
//    
//    func testSignin_badCredentials_pass() {
//        let db = client.getDatabase(name: "testAuth")
//        let repositories = HampyRepositories(mongoDatabase: db)
//        
//        defer {
//            repositories.close()
//            db.close()
//        }
//        
//        let auth = APIAuth(mongoDatabase: db, repositories: repositories)
//        
//        let json = """
//            {
//                "email" : "joanmramon@gmail.com",
//                "password" : "12345"
//            }
//        """
//        
//        let data = json.data(using: .utf8)!
//        let response = auth.signin(body: data)
//        
//        XCTAssertEqual(response.code, .notFound)
//    }
//    
//    func testRemoveDatabase() {
//        _ = client.getDatabase(name: "testAuth").drop()
//        client.close()
//    }
}
