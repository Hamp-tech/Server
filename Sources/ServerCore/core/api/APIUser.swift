//
//  APIUser.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import PerfectMongoDB

class APIUser: APIBase {
    
    // MARK: - APIAble
    override func routes() -> Routes {
        var routes = Routes()
        routes.add(update())
        routes.add(newCreditCard())
        routes.add(removeCreditCard())
        return routes
    }
}

private extension APIUser {
    
    // PRE: Is needed an existing user
    func update() -> Route {
        return Route(method: .put, uri: Schemes.Users.base, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler", event: .e)
                assert(false)
            }
            self.debug("Started")
            var hampyResponse = HampyResponse<HampyUser>()
            var user = try? HampySingletons.sharedJSONDecoder.decode(HampyUser.self, from: d)
            user?.identifier = request.urlVariables["id"]
            
            if let u = user {
                let result = self.repositories?.usersRepository.update(obj: u)
                
                switch result {
                case .success?:
                    hampyResponse.message = "User updated successfully"
                    hampyResponse.code = .ok
                   
                default:
                    hampyResponse.message = "User doesn't exists"
                    hampyResponse.code = .badRequest
                    
                }
            } else {
                hampyResponse.code = .badRequest
                hampyResponse.message = "Bad request"
            }
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    // PRE: Is needed an existing user
    func newCreditCard() -> Route {
        return Route(method: .post, uri: Schemes.Users.newCard, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler", event: .e)
                assert(false)
            }
            var hampyResponse =  HampyResponse<HampyCreditCard>()
            var user = self.repositories!.usersRepository.find(properties: ["identifier": request.urlVariables["id"]!]).first!
            
            do {
                self.debug("Creating card")
                var card = try HampySingletons.sharedJSONDecoder.decode(HampyCreditCard.self, from: d)
                StripeGateway.createCard(customer: user.stripeID!, card: card, completion: { (resp) in
                    hampyResponse.code = resp.code
                    hampyResponse.message = resp.message
                    if resp.code == .ok {
                        self.debug("Card created")
                        let token = resp.data!["id"] as? String
                        card.id = token
                        card.number = String(card.number!.suffix(4))
                        card.cvc = nil
                        user.cards?.append(card)
                        
                        _ = self.repositories?.usersRepository.update(obj: user)
                        
                        hampyResponse.message = "Card created successfully"
                        hampyResponse.data = card
                    } 
                    self.debug("Finished", event: resp.code == .ok ? .d : .e)
                    response.setBody(string: hampyResponse.json)
                    response.completed()
                })
                
            } catch let error {
                self.debug(error.localizedDescription, event: .e)
            }
        })
    }
    
    // PRE: Is needed an existing user
    
    func removeCreditCard() -> Route {
        return Route(method: .delete, uri: Schemes.Users.removeCard, handler: { (request, response) in
            let userId = request.urlVariables["id"]
            let cardId = request.urlVariables["cid"]
            
            guard let uid = userId, let cid = cardId else {
                self.debug("Handler", event: .e)
                assert(false)
            }
            
            var user = self.repositories!.usersRepository.find(properties: ["identifier": uid]).first!
            
            self.debug("Removing card")
            StripeGateway.removeCard(customer: user.stripeID!, cardId: cid, completion: { (resp) in
                var hampyResponse = resp
                
                switch resp.code {
                case .ok:
                    self.debug("Card removed")
                    if let idx = user.cards?.index(where: {$0.id == cid}) {
                         user.cards!.remove(at: idx)
                        _ = self.repositories?.usersRepository.update(obj: user)
                    }
                    var hampyResponse = resp
                    hampyResponse.message = "Card remove sucessfully"
                    hampyResponse.data = nil
                default:
                    break
                }
                
                hampyResponse.data = nil
                self.debug(hampyResponse.json)
                self.debug("Finished", event: resp.code == .ok ? .d : .e)
                response.setBody(string: hampyResponse.json)
                response.completed()
            })
        })
    }
}
