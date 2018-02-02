//
//  Stripeable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 2/2/18.
//

import PerfectHTTP

protocol Stripeable {
    typealias Params = [String: Any]
    typealias StripeResponse = (HampyResponse<[Params]>) -> ()
    
    static func createCostumer(userID: String, completion: @escaping StripeResponse)
    
    static func createCard(customer: String, completion: @escaping StripeResponse)
    
    static func pay(customer: String, cardToken: String, completion: @escaping StripeResponse)
    
    static func cards(customer: String, completion: @escaping StripeResponse)
    
    static func request(url: String, method: HTTPMethod, params: Params, completion: @escaping StripeResponse)
}
