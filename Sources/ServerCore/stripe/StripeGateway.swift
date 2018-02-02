//
//  StripeGateway.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 2/2/18.
//

import Foundation
import PerfectHTTP
import PerfectCURL

struct StripeGateway: Stripeable {
    static func createCustomer(userID: String, completion: @escaping Stripeable.StripeResponse) {
        let url = Schemes.URLs.Stripe.createCustomer.replacingOccurrences(of: "{id}", with: userID)
        let params = ["description": "Customer linked with \(userID)"]
        request(url: url, params: params, completion: completion)
    }
    
    static func createCard(customer: String, card: HampyCreditCard, completion: @escaping Stripeable.StripeResponse) {
        let url = Schemes.URLs.Stripe.createCard.replacingOccurrences(of: "{id}", with: customer)
        
        let dict = card.dict
        
        var aux = [String: Any]()
        aux["source[object]"] = "card"
        
        for (key, value) in dict {
            aux["source[\(key)]"] = value
        }

        request(url: url, params: aux, completion: completion)
    }
    
    static func pay(customer: String, cardToken: String, completion: @escaping Stripeable.StripeResponse) {
        
    }
    
    static func cards(customer: String, completion: @escaping Stripeable.StripeResponse) {
        
    }
    
    static func request(url: String, method: HTTPMethod = .post, params: Stripeable.Params? = nil, completion: @escaping Stripeable.StripeResponse) {
        let user = CURLRequest.Option.userPwd("sk_test_l2R4Rs5kioHANlDDkj2XlKxj")
        let contentType = CURLRequest.Option.addHeader(CURLRequest.Header.Name.contentType, "application/x-www-form-urlencoded")
        let met = CURLRequest.Option.httpMethod(method)
        let dataPost = CURLRequest.Option.postString(params?.toPostParams() ?? "")
        
        
        CURLRequest(url, options: [met, user, contentType, dataPost]).perform { (confirmation) in
            do {
                let resp = try confirmation()
                let code = HampyHTTPCode(code: resp.responseCode)
                var message: String
                
                switch code {
                case .ok:
                    message = "User created"
                default:
                    message = "Something wrong happened"
                }
                
                let hampyResponse = HampyResponse<[String : Any]>(code: code, message: message, data: resp.bodyJSON)
                completion(hampyResponse)
            } catch let error as CURLResponse.Error {
                print("Failed: response code \(error.response.bodyJSON)")
                Logger.d("FIRE COMPLETION HANDLER \(error.localizedDescription)", event: .e)
            } catch {
                print("Fatal error \(error)")
                Logger.d("FIRE COMPLETION HANDLER", event: .e)
            }
        }
    }
}

extension Dictionary {
    func toPostParams() -> String {        
        var s = self.reduce("", {"\($0)" + "\($1.key)=\($1.value)&"})
        s.removeLast()
        
        return s
    }
}
