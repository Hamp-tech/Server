//
//  APIPoints.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 5/2/18.
//

import Foundation
import PerfectHTTP
import PerfectWebSockets

#if os(Linux)
    import SwiftGlibc
    
    public func arc4random_uniform(_ max: UInt32) -> Int32 {
        return (SwiftGlibc.rand() % Int32(max-1))
    }
#endif

class APIPoints: APIBase {
    
    override func routes() -> Routes {
        var routes = Routes()
        routes.add(reset())
        return routes
    }
}

private extension APIPoints {
    func reset() -> Route {
        return Route(method: .post, uri: Schemes.URLs.Points.reset, handler: { (request, response) in
            let pid = request.urlVariables["pid"]!
            let lid = request.urlVariables["lid"]!
            
            self.debug("Started")
            let hampyResponse = self.resetLocker(pid: pid, lid: lid)
            self.debug(hampyResponse.json)
            self.debug("Finished", event: hampyResponse.code == .ok ? .d : .e)
            
            response.setBody(string: hampyResponse.json)
            response.completed()
        })
    }
}

extension APIPoints {
    func resetLocker(pid: String, lid: String) -> HampyResponse<String> {
        var point = self.repositories!.pointsRepository.find(properties: ["identifier": pid]).first
        var locker = point!.lockers!.filter{$0.identifier == lid}.first!
        locker.available = true
        locker.code = String(arc4random_uniform(10000)).leftPadding(toLength: 4, withPad: "0")
        point!.updateLocker(locker: locker)
        
        _ = try! self.repositories?.pointsRepository.update(obj: point!)
        
        
        return HampyResponse<String>(code: .ok, message: "Locker updated successfully")
    }
}

extension String {
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        
        guard toLength > self.count else { return self }
        
        let padding = String(repeating: withPad, count: toLength - self.count)

        return padding + self
    }
}
