//
//  APIHampyResponsesFactory.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 18/1/18.
//

import Foundation

struct APIHampyResponsesFactory {}

extension APIHampyResponsesFactory {
    struct Auth {
        static func signupOK(user: HampyUser) -> HampyResponse<HampyUser> {
            var u = HampyUser()
            u.password = nil
            u.lastActivity = nil
            u.language = nil
            u.tokenFCM = nil
            u.os = nil
            
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.code = .created
            hampyResponse.message = "User created successfully"
            hampyResponse.data = u
            
            return hampyResponse
        }
        
        static func signupFailConflict() -> HampyResponse<HampyUser> {
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.code = .conflict
            hampyResponse.message = "User already exists"
            
            return hampyResponse
        }
        
        static func signupFailUnknown() -> HampyResponse<HampyUser> {
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.code = .unknown
            hampyResponse.message = "Something wrong happened"
            
            return hampyResponse
        }
        
        static func signinOK(user: HampyUser) -> HampyResponse<HampyUser> {
            var u = user
            u.password = nil
            u.lastActivity = nil
            u.language = nil
            u.tokenFCM = nil
            u.os = nil
            
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.code = .ok
            hampyResponse.data = u
            
            return hampyResponse
        }
        
        static func signinFailBadRequest() -> HampyResponse<HampyUser> {
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.code = .badRequest
            hampyResponse.message = "Bad request"
            
            return hampyResponse
        }
        
        static func signinFailNotFound() -> HampyResponse<HampyUser> {
            var hampyResponse = HampyResponse<HampyUser>()
            hampyResponse.code = .notFound
            hampyResponse.message = "User doesn't exists"
            
            return hampyResponse
        }
    }
    
    struct Booking {
        static func bookingSuccess(booking: HampyBooking) -> HampyResponse<HampyBooking> {
            var hampyResponse = HampyResponse<HampyBooking>()
            hampyResponse.code = .ok
            hampyResponse.message = "Services booked"
            hampyResponse.data = booking
            
            return hampyResponse
        }
        
        static func bookingNotEnoughLockers() -> HampyResponse<HampyBooking> {
            var hampyResponse = HampyResponse<HampyBooking>()
            hampyResponse.code = .conflict
            hampyResponse.message = "Not enough  lockers to satisfy your necessities"
            
            return hampyResponse
        }
        
        static func bookingFailed() -> HampyResponse<HampyBooking> {
            var hampyResponse = HampyResponse<HampyBooking>()
            hampyResponse.code = .unknown
            hampyResponse.message = "Something wrong happened"
            
            return hampyResponse
        }
        
        static func bookingFailed(message: String) -> HampyResponse<HampyBooking> {
            var hampyResponse = HampyResponse<HampyBooking>()
            hampyResponse.code = .badRequest
            hampyResponse.message = message
            
            return hampyResponse
        }
    }
}
