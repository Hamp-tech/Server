//
//  APIUser.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP
import PerfectMongoDB

class APIUser: APIAble {
    
    // MARK: - Properties
    var mongoDatabase: MongoDatabase
    var repositories: HampyRepositories?
    
    // MARK: - Init
    required init(mongoDatabase: MongoDatabase, repositories: HampyRepositories? = nil) {
        self.mongoDatabase = mongoDatabase
        self.repositories = repositories
    }
    
    // MARK: - APIAble
    func routes() -> Routes {
        var routes = Routes()
        routes.add(update())
        routes.add(newCreditCard())
        return routes
    }
}

private extension APIUser {
    
    // PRE: Is needed an existing user
    func update() -> Route {
        return Route(method: .put, uri: Schemes.Users.base, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                Logger.d("Handler", event: .e)
                assert(false)
            }
            
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
            response.appendBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    // PRE: Is needed an existing user
    func newCreditCard() -> Route {
        return Route(method: .post, uri: Schemes.Users.newCard, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                Logger.d("Handler", event: .e)
                assert(false)
            }
            var hampyResponse =  HampyResponse<HampyCreditCard>()
            var user = self.repositories!.usersRepository.find(properties: ["identifier": request.urlVariables["id"]!]).first!
            
            do {
                var card = try HampySingletons.sharedJSONDecoder.decode(HampyCreditCard.self, from: d)
                StripeGateway.createCard(customer: user.stripeID!, card: card, completion: { (resp) in
                    hampyResponse.code = resp.code
                    hampyResponse.message = resp.message
                    if resp.code == .ok {
                        let token = resp.data!["id"] as? String
                        card.id = token
                        card.number = String(card.number!.suffix(4))
                        card.cvc = nil
                        user.cards?.append(card)
                        
                        _ = self.repositories?.usersRepository.update(obj: user)
                        
                        hampyResponse.message = "Card created successfully"
                        hampyResponse.data = card
                    }
                    
                    response.setBody(json: hampyResponse.json)
                    response.completed()
                })
                
            } catch let error {
                Logger.d(error.localizedDescription, event: .e)
            }
        })
    }
}
