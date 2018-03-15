//
//  FirebaseHandler.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 11/3/18.
//

import Foundation
import PerfectCURL

struct FirebaseHandler {
    
    static func sendNotification(notification: FirebaseNotification,
                                 completionBlock:((Error?) -> Void)? = nil) {
        let message = notification.message.json
        Logger.d("Sending notification: \(message)")

        let request = CURLRequest(
            Schemes.Firebase.projectURL,
            .failOnError,
            .addHeader(.authorization, "key=\(Schemes.Firebase.serverKey)"),
            .addHeader(.contentType, "application/json"),
            .httpMethod(.post),
            .postString(message)
        )
        request.perform { (confirmation) in
            do {
                let resp = try confirmation()
                completionBlock?(nil)
                Logger.d(resp.responseCode)
				Logger.d(resp.bodyString)
            } catch let error as CURLResponse.Error {
                completionBlock?(error)
                Logger.d("Curl error " + error.localizedDescription, event: .e)
            } catch {
                completionBlock?(error)
                Logger.d(error.localizedDescription, event: .e)
            }
        }
        
    }
}
