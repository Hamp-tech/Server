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
    typealias StripeResponse = (HampyResponse<[String: Any]>) -> ()
    
    static func createCustomer(userID: String, completion: @escaping StripeResponse) {
        let url = Schemes.URLs.Stripe.customers.replacingOccurrences(of: "{id}", with: userID)
        let params = ["description": "Customer linked with \(userID)"]
        request(url: url, params: params, completion: completion)
    }
    
    static func createCard(customer: String, card: HampyCreditCard, completion: @escaping StripeResponse) {
        let url = Schemes.URLs.Stripe.cards.replacingOccurrences(of: "{id}", with: customer)
        
        let dict = card.dict
        
        var aux = [String: Any]()
        aux["source[object]"] = "card"
        
        dict.forEach{aux["source[\($0)]"] = $1}

        request(url: url, params: aux, completion: completion)
    }
    
    static func removeCard(customer: String, cardId: String, completion: @escaping StripeResponse) {
        let url = Schemes.URLs.Stripe.removeCard.replacingOccurrences(of: "{id}", with: customer).replacingOccurrences(of: "{cid}", with: cardId)
        Logger.d(url)
        
        request(url: url, method: .delete, completion: completion)
    }
    
    static func cards(customer: String, completion: @escaping StripeResponse) {
        
    }
    
    static func pay(customer: String, cardToken: String, amount: Float32, userID: String, completion: @escaping StripeResponse) {
        
        let url = Schemes.URLs.Stripe.pay

        let params: [String: Any] = [
            "amount": Int(amount*100),
            "currency": "eur",
            "customer": customer,
            "source" : cardToken,
            "description": "Charge of \(amount) € to user \(userID)"
            ]

        request(url: url, params: params, completion: completion)
    }
    
    static func request(url: String, method: HTTPMethod = .post, params: [String: Any]? = nil, completion: @escaping StripeResponse) {
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
                    message = ""
                default:
                    message = "Something wrong happened"
					Logger.d(resp.bodyString, event: .e)
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
