//
//  APITransactions.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 28/1/18.
//

import Foundation
import PerfectMongoDB
import PerfectHTTP

class APITransactions: APIBase {
        
    override func routes() -> Routes {
        var routes = Routes()
        routes.add(newTransaction())
        routes.add(userTransactions())
        routes.add(deliver())
        routes.add(update())
        return routes
    }
}


private extension APITransactions {
    func newTransaction() -> Route {
        return Route(method: .post, uri: Schemes.URLs.transactions, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler", event: .e)
                assert(false)
            }
            self.debug("Started")
            self.newTransaction(data: d, userID: request.urlVariables["id"]!, completionBlock: { (resp) in
                self.debug(resp.json)
                self.debug("Finished", event: resp.code == .ok ? .d : .e)
                response.setBody(string: resp.json)
                response.completed()
            })
        })
    }
    
    func userTransactions() -> Route {
        return Route(method: .get, uri: Schemes.URLs.transactions, handler: { (request, response) in
            self.debug("Started")
            let hampyResponse = self.transactions(userID: request.urlVariables["id"]!)
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    func update() -> Route {
        return Route(method: .put, uri: Schemes.URLs.transactionsID, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler", event: .e)
                assert(false)
            }
            
            let hampyResponse = self.update(transactionID: request.urlVariables["tid"]!, data: d)
            
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    func deliver() -> Route {
        return Route(method: .post, uri: Schemes.URLs.transactionsDeliver, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                Logger.d("Handler", event: .e)
                assert(false)
            }
            
            let hampyResponse = self.deliver(transactionID: request.urlVariables["tid"]!, data: d)
            
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
}

internal extension APITransactions {
    func newTransaction(data: Data, userID: String, completionBlock: @escaping (HampyResponse<HampyTransaction>) -> ()) {
        var hampyResponse: HampyResponse<HampyTransaction>!
        
        do {
            var transaction = try HampySingletons.sharedJSONDecoder.decode(HampyTransaction.self, from: data)
            transaction.userID = userID
            transaction.identifier = UUID.generateHampIdentifier()
            transaction.pickUpDate = Date().iso8601()
            
            let basketSizes = self.basketSizes(booking: transaction.booking!)
            
            // Calculate if we have enought lockers to put the basket
            // 1st Version
            self.debug("Calculating number of lockers")
            let size = basketSizes.first!
            
            var point = self.repositories!.pointsRepository.find(properties: ["identifier": transaction.booking!.point!]).first!
            let lockers = point.freeLockers(with: size)
            
            
            guard let l = lockers?.first else {
                self.debug("Not enough lockers. Lockers needed \(0) and \(lockers?.count ?? 0) available")
                hampyResponse = APIHampyResponsesFactory.Transaction.transactionNotEnoughLockers()
                completionBlock(hampyResponse)
                return
            }
            
            let user = self.repositories!.usersRepository.find(properties: ["identifier": userID]).first!
            
            // START Stripe
            self.debug("Paying")
            StripeGateway.pay(customer: user.stripeID!,
                              cardToken: transaction.creditCardIdentifier!,
                              amount: transaction.booking!.price!,
                              userID: userID,
                              completion: { (resp) in
                
                if resp.code == .ok {
                    self.debug("Paid successfully")
                    let _ = self.updatePoint(transaction: &transaction, point: &point, lockers: [l])
                    let _ = self.createTransaction(transaction: &transaction)
                    
                    hampyResponse = APIHampyResponsesFactory.Transaction.transactionSuccess(transaction: transaction)
                } else {
                    self.debug("Paid error: \(resp.message)", event: .e)
                    hampyResponse = APIHampyResponsesFactory.Transaction.transactionStripeFailed()
                }
                
                completionBlock(hampyResponse)
            })
            // END PAY STRIPE
            
            // END 1st Version
        } catch let error {
            self.debug(error.localizedDescription, event: .e)
            hampyResponse = APIHampyResponsesFactory.Transaction.transactionFailed(message: error.localizedDescription)
            completionBlock(hampyResponse)
        }
    }
    
    func transactions(userID: String) -> HampyResponse<Array<HampyTransaction>> {
        let transactions = repositories?.transactionsRepository.find(properties: ["userID": userID])
        return HampyResponse<Array<HampyTransaction>>(code: .ok, data: transactions)
    }
    
    func update(transactionID: String, data: Data) -> HampyResponse<HampyTransaction> {
        var hampyResponse = HampyResponse<HampyTransaction>()
        
        let transactionID = transactionID
        var transaction = self.repositories!.transactionsRepository.find(properties: ["identifier" : transactionID]).first!
        do {
            let auxTransaction = try HampySingletons.sharedJSONDecoder.decode(HampyTransaction.self, from: data)
            transaction.phase = auxTransaction.phase
            
            _ = self.repositories?.transactionsRepository.update(obj: transaction)
            
            // Send push, sms to user
            
            hampyResponse.code = .ok
            hampyResponse.data = transaction
            
            
        } catch let error {
            self.debug(error.localizedDescription, event: .e)
        }
        
        return hampyResponse
    }
    
    func deliver(transactionID: String, data: Data) -> HampyResponse<HampyTransaction> {
        var hampyResponse = HampyResponse<HampyTransaction>()
        
        var transaction = self.repositories!.transactionsRepository.find(properties: ["identifier" : transactionID]).first!
        let point = self.repositories?.pointsRepository.find(properties: ["identifier": transaction.booking!.point!]).first!
        
        do {
            let booking = try HampySingletons.sharedJSONDecoder.decode(HampyBooking.self, from: data)
            let numbers = booking.deliveryLockers!.map{$0.number!}
            let lockers = point?.findLockers(numbersOfLocker: numbers)
            transaction.booking?.deliveryLockers = lockers
            transaction.phase = .toDeliver
            transaction.deliveryDate = Date().iso8601()
            _ = self.repositories?.transactionsRepository.update(obj: transaction)
            
            let user = self.repositories?.usersRepository.find(properties: ["identifier": transaction.userID!]).first!
            
            if let token = user?.tokenFCM {
                self.debug("Sending firebase notification")
                FirebaseGateway.sendNotification(token: token, params: [:], completion: { (resp) in
                    self.debug(resp.json)
                })
            }
            hampyResponse.code = .ok
            hampyResponse.data = transaction
            
        } catch let error {
            Logger.d(error.localizedDescription, event: .e)
        }
        
        return hampyResponse
    }
}

private extension APITransactions {
    func basketSizes(booking: HampyBooking) -> [Size] {
        let servicesIdentifiers = booking.basket?.map{ ["identifier" : $0.service as Any] }
        let services = self.repositories?.servicesRepository.find(elements: servicesIdentifiers!)
        
        return services!.map{$0.size!}
    }
    
    func updatePoint(transaction: inout HampyTransaction, point: inout HampyPoint, lockers: [HampyLocker]) -> (updated: Bool, errorResponse: HampyResponse<HampyTransaction>?) {
        lockers.forEach {
            var l = $0
            l.available = false
            point.updateLocker(locker: l)
        }
        
        transaction.booking?.pickUpLockers = lockers
        
        let result = repositories!.pointsRepository.update(obj: point)
        
        if case .success = result { return (true, nil) }
        
        return (false, APIHampyResponsesFactory.Transaction.transactionFailed(message: "Error updating point"))
    }
    
    func createTransaction(transaction: inout HampyTransaction) ->  (created: Bool, errorResponse: HampyResponse<HampyTransaction>?) {
        transaction.phase = .toPickUp
        let result = repositories!.transactionsRepository.create(obj: transaction)
        
        if case .success = result { return (true, nil) }
        
        return (false, APIHampyResponsesFactory.Transaction.transactionFailed(message: "Error saving transaction"))
    }
    
    
}