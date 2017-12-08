//
//  APIStripe.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import PerfectCURL

class APIStripe {
    func routes() -> Routes {
        var routes = Routes()
        routes.add(pay())
        return routes
    }
    
}

private extension APIStripe {
    
    func pay() -> Route {
        return Route(method: .post, uri: "/api/v1/pay/{token}", handler: { request, response in
            
            let url = "https://api.stripe.com/v1/charges"
            
            var data = "amount=\(2)&"
                data += "currency=eur&"
                data += "description=\("Example")&"
                data += "source=\(request.urlVariables["token"]!)"
            
            self.connectWithStripe(url: url, data: data, completion: { (hampyResponse) in
                response.setBody(json: hampyResponse.json)
                response.completed()
            })
            
        
        })
    }
    
    func connectWithStripe(url: String, method: HTTPMethod = .post, data: String, completion: @escaping (HampyResponse) -> ()) {
        let user = CURLRequest.Option.userPwd("sk_test_l2R4Rs5kioHANlDDkj2XlKxj")
        let contentType = CURLRequest.Option.addHeader(CURLRequest.Header.Name.contentType, "application/x-www-form-urlencoded")
        let met = CURLRequest.Option.httpMethod(method)
        let dataPost = CURLRequest.Option.postString(data)
        
        CURLRequest(url, options: [met, user, contentType, dataPost]).perform { (confirmation) in
            do {
                let resp = try confirmation()
                let error = HampyHTTPCode(code: resp.responseCode)
                
                completion(HampyResponse(code: error))
            } catch let error as CURLResponse.Error {
                print("Failed: response code \(error.response.responseCode)")
            } catch {
                print("Fatal error \(error)")
            }
        }
    }
}


