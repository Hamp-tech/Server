//
//  APIBooking.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 19/1/18.
//

import Foundation
import PerfectHTTP
import PerfectMongoDB

class APIBooking: APIAble {
    
    typealias T = HampyPoint
    
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
        routes.add(newBooking())
        return routes
    }
}

private extension APIBooking {
    func newBooking() -> Route {
        return Route(method: .post, uri: Schemes.Booking.newBooking, handler: { (request, response) in
            let data = request.postBodyString?.data(using: .utf8)
            guard let d = data else { assert(false) }
        

            let hampyResponse = self.booking(data: d, request: request)
            
            response.setBody(json: hampyResponse.json)
            response.completed()
        })
    }
}

internal extension APIBooking {
    func booking(data: Data, request: HTTPRequest) -> HampyResponse<HampyBooking> {
        var hampyResponse: HampyResponse<HampyBooking> = HampyResponse()
        
        do {
            var booking = try HampySingletons.sharedJSONDecoder.decode(HampyBooking.self, from: data)
            booking.userID = request.urlVariables["id"]
            
            // Get services booked
            let size = basketSizes(booking: booking).first
            
            // Get point associated
            var point = self.repositories!.pointsRepository.find(properties: ["identifier" : booking.point!]).first!
            let lockers = point.freeLockers(with: size!)
            
            // Lockers available
            if var l = lockers?.first {
                l.available = false
                point.updateLocker(locker: l)
                
                let result = self.repositories?.pointsRepository.update(obj: point)
                
                switch result {
                case .success?:
                    booking.identifier = UUID.generateHampIdentifier()
                    booking.deliveryLocker = l
                    hampyResponse = APIHampyResponsesFactory.Booking.bookingSuccess(booking: booking)
                default:
                    hampyResponse = APIHampyResponsesFactory.Booking.bookingFailed()
                }
            } else {
                // No lockers available to this booking
                hampyResponse = APIHampyResponsesFactory.Booking.bookingNotEnoughLockers()
            }
        } catch let error {
            hampyResponse = APIHampyResponsesFactory.Booking.bookingFailed(message: error.localizedDescription)
        }
        
        return hampyResponse
    }
}

private extension APIBooking {
    func basketSizes(booking: HampyBooking) -> [Size] {
        let servicesIdentifiers = booking.basket?.map{ ["identifier" : $0.service as Any] }
        let services = self.repositories?.servicesRepository.find(elements: servicesIdentifiers!)
        
        return services!.map{$0.size!}
    }
}
