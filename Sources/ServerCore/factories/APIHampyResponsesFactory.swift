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
            let u = HampyUser()
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
            let u = user
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
}
