//
//  APIPoints.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 5/2/18.
//

import Foundation
import PerfectHTTP
import PerfectWebSockets

class EchoHandler: WebSocketSessionHandler {
    
    // The name of the super-protocol we implement.
    // This is optional, but it should match whatever the client-side WebSocket is initialized with.
    let socketProtocol: String? = "echo"
    
    // This function is called by the WebSocketHandler once the connection has been established.
    func handleSession(request: HTTPRequest, socket: WebSocket) {
        
        // Read a message from the client as a String.
        // Alternatively we could call `WebSocket.readBytesMessage` to get the data as an array of bytes.
        socket.readStringMessage {
            // This callback is provided:
            //  the received data
            //  the message's op-code
            //  a boolean indicating if the message is complete
            // (as opposed to fragmented)
            string, op, fin in
            
            // The data parameter might be nil here if either a timeout
            // or a network error, such as the client disconnecting, occurred.
            // By default there is no timeout.
            guard let string = string else {
                // This block will be executed if, for example, the browser window is closed.
                socket.close()
                return
            }
            
            // Print some information to the console for informational purposes.
            print("Read msg: \(string) op: \(op) fin: \(fin)")
            
            // Echo the data received back to the client.
            // Pass true for final. This will usually be the case, but WebSockets has
            // the concept of fragmented messages.
            // For example, if one were streaming a large file such as a video,
            // one would pass false for final.
            // This indicates to the receiver that there is more data to come in
            // subsequent messages but that all the data is part of the same logical message.
            // In such a scenario one would pass true for final only on the last bit of the video.
            socket.sendStringMessage(string: string, final: true) {
                
                // This callback is called once the message has been sent.
                // Recurse to read and echo new message.
                self.handleSession(request: request, socket: socket)
            }
        }
    }
}

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
//        locker.code = String(arc4random_uniform(9999)).leftPadding(toLength: 4, withPad: "0")
        point!.updateLocker(locker: locker)
        
        _ = self.repositories?.pointsRepository.update(obj: point!)
        
        
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
