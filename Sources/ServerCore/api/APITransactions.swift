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
        return routes
    }
}


private extension APITransactions {
    func newTransaction() -> Route {
        return Route(method: .post, uri: Schemes.URLs.transactions, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else { assert(false) }
            
            var hampyResponse: HampyResponse<HampyTransaction>!
            
            do {
                var transaction = try HampySingletons.sharedJSONDecoder.decode(HampyTransaction.self, from: d)
                transaction.userID = request.urlVariables["id"]
                transaction.identifier = UUID.generateHampIdentifier()
                
                let basketSizes = self.basketSizes(booking: transaction.booking!)
                
                // Calculate if we have enought lockers to put the basket
                
                // 1st Version
                let size = basketSizes.first!
                
                var point = self.repositories!.pointsRepository.find(properties: ["identifier": transaction.booking!.point!]).first!
                let lockers = point.freeLockers(with: size)
                
                if let l = lockers?.first {
                    
                    // PAY STRIPE
                    StripeManager.pay(cardID: "123", amount: 10, completionHandler: { (resp) in
                        
//                        if resp == success { }
//                        else { }
                        
                        let updatePointResult = self.updatePoint(transaction: transaction, point: &point, lockers: [l])
                        if updatePointResult.updated {
                            let createTransactionResult = self.createTransaction(transaction: transaction)
                            if createTransactionResult.created {
                                hampyResponse = APIHampyResponsesFactory.Transaction.transactionSuccess(transaction: transaction)
                            } else {
                               hampyResponse = createTransactionResult.errorResponse!
                            }
                        } else {
                            hampyResponse = updatePointResult.errorResponse!
                        }
                    })
                    // END PAY STRIPE
                } else {
                    hampyResponse = APIHampyResponsesFactory.Transaction.transactionNotEnoughLockers()
                }
                // END 1st Version
            } catch let error {
                hampyResponse = APIHampyResponsesFactory.Transaction.transactionFailed(message: error.localizedDescription)
            }
            
            response.setBody(json: hampyResponse.json)
            response.completed()
            
        })
    }
}

private extension APITransactions {
    func basketSizes(booking: HampyBooking) -> [Size] {
        let servicesIdentifiers = booking.basket?.map{ ["identifier" : $0.service as Any] }
        let services = self.repositories?.servicesRepository.find(elements: servicesIdentifiers!)
        
        return services!.map{$0.size!}
    }
    
    func updatePoint(transaction: HampyTransaction, point: inout HampyPoint, lockers: [HampyLocker]) -> (updated: Bool, errorResponse: HampyResponse<HampyTransaction>?) {
        lockers.forEach {
            var l = $0
            l.available = false
            point.updateLocker(locker: $0)
        }
        
        let result = repositories!.pointsRepository.update(obj: point)
        
        if case .success = result { return (true, nil) }
        
        return (false, APIHampyResponsesFactory.Transaction.transactionFailed(message: "Error updating point"))
    }
    
    func createTransaction(transaction: HampyTransaction) ->  (created: Bool, errorResponse: HampyResponse<HampyTransaction>?) {
        let result = repositories!.transactionsRepository.create(obj: transaction)
        
        if case .success = result { return (true, nil) }
        
        return (false, APIHampyResponsesFactory.Transaction.transactionFailed(message: "Error saving transaction"))
    }
    
    
}
