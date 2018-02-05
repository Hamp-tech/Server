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
        
        StripeGateway.createCustomer(userID: "1234") { (response) in
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
        StripeGateway.createCard(customer: "cus_CFJ0E06fxO4iBi", card: HampyCreditCard(id: nil, number: "4242424242424242", exp_month: 12, exp_year: 21, cvc: "333")) { (response) in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                Logger.d(error.localizedDescription)
            }
        }
        
        
    }
    
}
