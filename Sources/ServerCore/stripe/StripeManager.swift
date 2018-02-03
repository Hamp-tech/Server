//
//  StripeManager.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import PerfectCURL
import PerfectMongoDB

class StripeManager {
    
    // MARK: - Public API
    static func pay(costumerID: String,
                    cardID: String = "",
                    amount: Float32,
                    completionHandler: (HampyResponse<HampyUser>) -> ()) {
        
        
        completionHandler(HampyResponse<HampyUser>())
    }
    
    static func createCustomer(userID: String,
                               completionHandler: @escaping (HampyResponse<[String: Any]>) -> ()) {
        let url = Schemes.URLs.Stripe.createCustomer
        
        let data = "description=Costumer associated to \(userID)"
        
        self.connectWithStripe(url: url, data: data, completion: completionHandler)
    }
    
    static func createCard(customerID: String,
                           card: String,
                           completionHandler: @escaping (HampyResponse<[String: Any]>) -> ()) {
        let url = Schemes.URLs.Stripe.createCard.replacingOccurrences(of: "{id}", with: customerID)
        
        let card = [
            "object" : "card",
            "number" : "4242424242424242",
            "exp_month" : "12",
            "exp_year" : "21",
            "cvc": "222",
        ]
        
        let foo = "source=[object=card&number=4242424242424242&exp_month=12&exp_year=21&cvc=222]"
        let bar = "source:{\"object\": \"card\", \"number\": \"4242424242424242\", \"exp_month\": 12, \"exp_year\": 21, \"cvc\": 222 }"
        
        
        
        let json = String.init(data: try!HampySingletons.sharedJSONEncoder.encode(card), encoding: .utf8)
        let data = "source=\(json!)"
        self.connectWithStripe(url: url, data: foo) { (response) in
            Logger.d(response)
        }
    }
    
    
}

private extension StripeManager {
    
    func addCard() -> Route {
        return Route(method: .post, uri: "/api/v1/cards/{customer_id}", handler: { request, response in
            let customerID = request.urlVariables["customer_id"]!
            
            let url = "https://api.stripe.com/v1/customers/\(customerID)/sources"
            
            let data = "source=\("tok_visa_debit")"
            
//            self.connectWithStripe(url: url, data: data, completion: { (hampyResponse) in
//                response.setBody(json: hampyResponse.json)
//                response.completed()
//            })
        })
    }
}

private extension StripeManager {
    // MARK: - Helper
    static func connectWithStripe(url: String, method: HTTPMethod = .post, data: String, completion: @escaping (HampyResponse<[String : Any]>) -> ()) {
        let user = CURLRequest.Option.userPwd("sk_test_l2R4Rs5kioHANlDDkj2XlKxj")
        let contentType = CURLRequest.Option.addHeader(CURLRequest.Header.Name.contentType, "application/x-www-form-urlencoded")
        let met = CURLRequest.Option.httpMethod(method)
        let dataPost = CURLRequest.Option.postString(data)
        
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


