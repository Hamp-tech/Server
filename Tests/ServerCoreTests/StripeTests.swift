//
//  StripeTests.swift
//  ServerCoreTests
//
//  Created by Joan Molinas Ramon on 1/2/18.
//

import XCTest
@testable import ServerCore

class StripeTests: XCTestCase {
    

    func testCreateCostumer() {
        
        let exp = expectation(description: "POST: Stripe create costumer")
        
        StripeManager.createCustomer(userID: "1234") { (response) in
            XCTAssertEqual(response.code, .ok)
            Logger.d(response)
            exp.fulfill()
        }
    
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                Logger.d(error.localizedDescription)
            }
        }
    }
    
    func testCreateCard() {
        let exp = expectation(description: "POST: Stripe create card")
        StripeManager.createCard(customerID: "cus_CFJ0E06fxO4iBi", card: "") { (response) in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                Logger.d(error.localizedDescription)
            }
        }
        
        
    }
    
}
