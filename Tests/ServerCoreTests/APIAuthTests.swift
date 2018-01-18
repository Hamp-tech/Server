import Foundation
import XCTest
@testable import ServerCore
import PerfectMongoDB

class APIAuthTests: XCTestCase {
    
    let client = try! MongoClient(uri: "mongodb://localhost")
    
    func testSignup_newUser() {
        
        let db = client.getDatabase(name: "testAuth")
        let repository = HampyUsersRepository(mongoDatabase: db)
        let auth = APIAuth(mongoDatabase: db, repository: repository)
        
        defer {
            repository.close()
            db.close()
        }
    
        let randomNum = arc4random_uniform(100000)
        let email = "\(randomNum)@gmail.com"
        
        let json = """
            {
                "name" : "Joannnn",
                "surname" : "Molinas",
                "email" : "\(email)",
                "password" : "1234567890",
                "phone" : "646548142",
                "gender" : "M",
                "tokenFCM" : "tokeeeeen",
                "os" : "ios",
                "language" : "esES"
            }
        """
        
        let data = json.data(using: .utf8)!
        let response = auth.signup(body: data)
        
        XCTAssertEqual(response.code, .created)
    }
    
    func testSignup_existentUser() {
        let db = client.getDatabase(name: "testAuth")
        let repository = HampyUsersRepository(mongoDatabase: db)
        
        defer {
            repository.close()
            db.close()
        }
        
        let auth = APIAuth(mongoDatabase: db, repository: repository)
        
        let json = """
            {
                "name" : "Joannnn",
                "surname" : "Molinas",
                "email" : "98355@gmail.com",
                "password" : "1234567890",
                "phone" : "646548142",
                "gender" : "M",
                "tokenFCM" : "tokeeeeen",
                "os" : "ios",
                "language" : "esES"
            }
        """
        
        let data = json.data(using: .utf8)!
        let response = auth.signup(body: data)
        
        XCTAssertEqual(response.code, .conflict)
        
    }
    
    func testSignin_existentCredentials() {
        let db = client.getDatabase(name: "testAuth")
        let repository = HampyUsersRepository(mongoDatabase: db)
        
        defer {
            repository.close()
            db.close()
        }
        
        let auth = APIAuth(mongoDatabase: db, repository: repository)
        
        let json = """
            {
                "email" : "98355@gmail.com",
                "password" : "1234567890"
            }
        """
        
        let data = json.data(using: .utf8)!
        let response = auth.signin(body: data)
        
        XCTAssertEqual(response.code, .ok)
    }
    
    func testSignin_badCredentials_email() {
        let db = client.getDatabase(name: "testAuth")
        let repository = HampyUsersRepository(mongoDatabase: db)
        
        defer {
            repository.close()
            db.close()
        }
        
        let auth = APIAuth(mongoDatabase: db, repository: repository)
        
        let json = """
            {
                "email" : "9835511@gmail.com",
                "password" : "1234567890"
            }
        """
        
        let data = json.data(using: .utf8)!
        let response = auth.signin(body: data)
        
        XCTAssertEqual(response.code, .notFound)
    }
    
    func testSignin_badCredentials_pass() {
        let db = client.getDatabase(name: "testAuth")
        let repository = HampyUsersRepository(mongoDatabase: db)
        
        defer {
            repository.close()
            db.close()
        }
        
        let auth = APIAuth(mongoDatabase: db, repository: repository)
        
        let json = """
            {
                "email" : "98355@gmail.com",
                "password" : "12345"
            }
        """
        
        let data = json.data(using: .utf8)!
        let response = auth.signin(body: data)
        
        XCTAssertEqual(response.code, .notFound)
    }
}
