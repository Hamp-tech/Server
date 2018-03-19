//
//  APITransactions.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 28/1/18.
//

import Foundation
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
        return Route(method: .post, uri: Schemes.URLs.Transactions.transactions, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler", event: .e)
                assert(false)
                return
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
        return Route(method: .get, uri: Schemes.URLs.Transactions.transactions, handler: { (request, response) in
            self.debug("Started")
            let hampyResponse = self.transactions(userID: request.urlVariables["id"]!)
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    func update() -> Route {
        return Route(method: .put, uri: Schemes.URLs.Transactions.transactionsID, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                self.debug("Handler", event: .e)
                assert(false)
                return
            }
            
            let hampyResponse = self.update(transactionID: request.urlVariables["tid"]!, data: d)
            
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
    
    func deliver() -> Route {
        return Route(method: .post, uri: Schemes.URLs.Transactions.transactionsDeliver, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else {
                Logger.d("Handler", event: .e)
                assert(false)
                return
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
            let transaction = try HampySingletons.sharedJSONDecoder.decode(HampyTransaction.self, from: data)
            transaction.userID = userID
            transaction.identifier = UUID.generateHampIdentifier()
            transaction.pickUpDate = Date().iso8601()
            
            let services = self.basketServices(booking: transaction.booking!)
			
			let point = self.repositories!.pointsRepository.find(properties: ["identifier": transaction.booking!.point!.identifier]).first
			transaction.booking?.point = point
			
			self.debug("Calculating number of lockers")
			let lockers = LockersToServiceCalculator.lockers(to: services, point: point!)
			
            guard lockers.count > 0 else {
                self.debug("Not enough lockers. Lockers needed \(0) and \(0) available")
                hampyResponse = APIHampyResponsesFactory.Transaction.transactionNotEnoughLockers()
                completionBlock(hampyResponse)
                return
            }
            
            let user = self.repositories!.usersRepository.find(properties: ["identifier": userID]).first!
			let card = user.cards?.filter { $0.id == transaction.creditCard?.id }.first
			transaction.creditCard = card
            
            // START Stripe
            self.debug("Paying")
            StripeGateway.pay(customer: user.stripeID!,
                              cardToken: transaction.creditCard!.id!,
                              amount: transaction.booking!.price!,
                              userID: userID,
                              completion: { (resp) in
                                
                                if resp.code == .ok {
                                    self.debug("Paid successfully")
                                    self.updatePoint(transaction: transaction, point: point!, lockers: lockers)
                                    self.createTransaction(transaction: transaction)
                                    transaction.hidePropertiesToResponse()
									
									hampyResponse = APIHampyResponsesFactory.Transaction.transactionSuccess(transaction: transaction)
                                } else {
                                    self.debug("Paid error: \(resp.message)", event: .e)
                                    hampyResponse = APIHampyResponsesFactory.Transaction.transactionStripeFailed()
                                }
                                
                                completionBlock(hampyResponse)
            })
            // END PAY STRIPE
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
        let hampyResponse = HampyResponse<HampyTransaction>()
        
        let transactionID = transactionID
        let transaction = self.repositories!.transactionsRepository.find(properties: ["identifier" : transactionID]).first!
        do {
            let auxTransaction = try HampySingletons.sharedJSONDecoder.decode(HampyTransaction.self, from: data)
//            transaction.phases = auxTransaction.phases
			
            _ = try! self.repositories?.transactionsRepository.update(obj: transaction)
			
            hampyResponse.code = .ok
            hampyResponse.data = transaction
            
            
        } catch let error {
            self.debug(error.localizedDescription, event: .e)
        }
        
        return hampyResponse
    }
    
    func deliver(transactionID: String, data: Data) -> HampyResponse<HampyTransaction> {
        let hampyResponse = HampyResponse<HampyTransaction>()
        
        let transaction = self.repositories!.transactionsRepository.find(properties: ["identifier" : transactionID]).first!
        let point = self.repositories?.pointsRepository.find(properties: ["identifier": transaction.booking!.point?.identifier]).first!
        
        do {
            let booking = try HampySingletons.sharedJSONDecoder.decode(HampyBooking.self, from: data)
            let numbers = booking.deliveryLockers!.map{$0.number}
//            let lockers = point?.findLockers(numbersOfLocker: numbers)
//            transaction.booking?.deliveryLockers = lockers
            transaction.deliveryDate = Date().iso8601()
            _ = try! self.repositories?.transactionsRepository.update(obj: transaction)
            
            let user = self.repositories?.usersRepository.find(properties: ["identifier": transaction.userID!]).first!
            
            if let token = user?.tokenFCM {
                self.debug("Sending firebase notification")
                FirebaseHandler.sendNotification(
                    notification: FirebaseNotification(
                        message: FirebaseNotificationMessage(
                            token: token,
                            body: FirebaseNotificationMessageBody(
                                title: "Roba neta 😍!",
                                body: "Ja pots recollir la roba a la taquilla 3 💃🏻!"
                            )
                        )
                    )
                )
            } else {
                // Send sms
            }
            hampyResponse.code = .ok
            hampyResponse.data = transaction
            
        } catch let error {
            Logger.d(error.localizedDescription, event: .e)
        }
        
        return hampyResponse
    }
}

class _HampyHiredService {
	var amount: Int
	var service: HampyService
	
	init(amount: Int, service: HampyService) {
		self.amount = amount
		self.service = service
	}
}

private extension APITransactions {
	func basketServices(booking: HampyBooking) -> [_HampyHiredService] {
	
		let servicesHired = booking.basket?.map{ (["identifier" : $0.service as Any], $0.amount) }
		let services = self.repositories!.servicesRepository.find(elements: servicesHired!.map{$0.0})
		
		var _services = [_HampyHiredService]()
		for s in services {
			let amount = servicesHired!.filter{($0.0["identifier"] as! String) == s.identifier}.first!.1!
			let _service = _HampyHiredService(amount: amount, service: s)
			_services.append(_service)
		}
        return _services
    }

    func updatePoint(transaction: HampyTransaction, point: HampyPoint, lockers: [HampyLocker]) {
        lockers.forEach { $0.available = false }
        transaction.booking?.pickUpLockers = lockers
        let _ = try! repositories!.pointsRepository.update(obj: point)
    }
	
    
    func createTransaction(transaction: HampyTransaction) {
        let _ = try! repositories!.transactionsRepository.create(obj: transaction)
    }
}
