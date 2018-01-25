//
//  APIKeyRequestFilter.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 9/12/17.
//

import PerfectHTTP

struct APIKeyRequestFilter: HTTPRequestFilter {
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        let hasKey = request.headers.contains{$0.1 == "QfTjWnZr4u7x!A%D*G-JaNdRgUkXp2s5"}
        
        if hasKey {
            callback(.continue(request, response))
        } else {
            response.setBody(json: HampyResponse<String>(code: .unauthorized).json)
            callback(.halt(request, response))
        }
    }
}
