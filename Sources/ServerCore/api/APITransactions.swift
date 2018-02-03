//
//  APITransactions.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 28/1/18.
//

import Foundation
import PerfectMongoDB
import PerfectHTTP

struct APITransactions: APIAble {
    
    // MARK: - Propertties
    var mongoDatabase: MongoDatabase
    var repositories: HampyRepositories?
    
    // MARK: - Life cycle
    init(mongoDatabase: MongoDatabase, repositories: HampyRepositories? = nil) {
        self.mongoDatabase = mongoDatabase
        self.repositories = repositories
    }
    
    func routes() -> Routes {
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
                Logger.d("Handler", event: .e)
                assert(false)
            }
            
            self.newTransaction(data: d, userID: request.urlVariables["id"]!, completionBlock: { (resp) in
                response.setBody(json: resp.json)
                response.completed()
            })
        })
    }
    
    func userTransactions() -> Route {
        return Route(method: .get, uri: Schemes.URLs.transactions, handler: { (request, response) in
            
            let hampyResponse = self.transactions(userID: request.urlVariables["id"]!)
            response.setBody(json: hampyResponse.json)
            response.completed()
        })
    }
    
    func update() -> Route {
        return Route(method: .put, uri: Schemes.URLs.transactionsID, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                Logger.d("Handler", event: .e)
                assert(false)
            }
            
            let hampyResponse = self.update(transactionID: request.urlVariables["tid"]!, data: d)
            
            response.setBody(json: hampyResponse.json)
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
            
            response.setBody(json: hampyResponse.json)
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
            //                transaction.state = .initial
            
            let basketSizes = self.basketSizes(booking: transaction.booking!)
            
            // Calculate if we have enought lockers to put the basket
            // 1st Version
            let size = basketSizes.first!
            
            var point = self.repositories!.pointsRepository.find(properties: ["identifier": transaction.booking!.point!]).first!
            let lockers = point.freeLockers(with: size)
            
            if let l = lockers?.first {
                StripeGateway.pay(customer: userID, cardToken: transaction.creditCardIdentifier!, amount: transaction.booking!.price!, completion: { (resp) in
                    
                    if resp.code == .ok {
                        let updatePointResult = self.updatePoint(transaction: &transaction, point: &point, lockers: [l])
                        let createTransactionResult = self.createTransaction(transaction: &transaction)
                        
                        if updatePointResult.updated && createTransactionResult.created {
                            hampyResponse = APIHampyResponsesFactory.Transaction.transactionSuccess(transaction: transaction)
                        } else {
                            hampyResponse = APIHampyResponsesFactory.Transaction.transactionFailed()
                        }
                    } else {
                        hampyResponse = APIHampyResponsesFactory.Transaction.transactionStripeFailed()
                    }
                    
                    completionBlock(hampyResponse)
                })
                // END PAY STRIPE
            } else {
                hampyResponse = APIHampyResponsesFactory.Transaction.transactionNotEnoughLockers()
                completionBlock(hampyResponse)
            }
            // END 1st Version
        } catch let error {
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
            Logger.d(error.localizedDescription)
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
            
            // Send push, sms to user
            
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
