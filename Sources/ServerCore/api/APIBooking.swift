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
        

            let hampyResponse = self.booking(data: d, userID: request.urlVariables["id"]!)
            
            response.setBody(json: hampyResponse.json)
            response.completed()
        })
    }
}

internal extension APIBooking {
    func booking(data: Data, userID: String) -> HampyResponse<HampyBooking> {
        var hampyResponse: HampyResponse<HampyBooking> = HampyResponse()
        
        do {
            var booking = try HampySingletons.sharedJSONDecoder.decode(HampyBooking.self, from: data)
            booking.userID = userID
            
            // Get services booked
            let size = basketSizes(booking: booking).first
            
            // Get point associated
            var point = self.repositories!.pointsRepository.find(properties: ["identifier" : booking.point!]).first!
            let lockers = point.freeLockers(with: size!)
            
            // Lockers available
            if var l = lockers?.first {
                l.available = false
                
                booking.identifier = UUID.generateHampIdentifier()
                booking.deliveryLockers = [l]
                
                let result = saveBooking(booking: booking)
                
                switch result {
                case .success:
                    
                    let result = updateLocker(point: &point, locker: l)
                    switch result {
                    case .success:
                        hampyResponse = APIHampyResponsesFactory.Booking.bookingSuccess(booking: booking)
                    default:
                        hampyResponse = APIHampyResponsesFactory.Booking.bookingFailed()
                    }
                
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
    
    // Return if was saved or not
    func saveBooking(booking: HampyBooking) -> MongoResult {
        let repository = repositories!.bookingRepository
        return repository.create(obj: booking)
    }
    
    func updateLocker(point: inout HampyPoint, locker: HampyLocker) -> MongoResult {
        point.updateLocker(locker: locker)
        return repositories!.pointsRepository.update(obj: point)
    }
}








