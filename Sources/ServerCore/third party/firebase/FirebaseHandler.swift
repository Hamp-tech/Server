//
//  FirebaseHandler.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 11/3/18.
//

import Foundation
import PerfectCURL

struct FirebaseHandler {
    
    static func sendNotification(notification: FirebaseNotification) {
        let message = """
			{
			  "message":{
				"token" : "bk3RNwTe3H0:CI2k_HHwgIpoDKCIZvvDMExUdFQ3P1...",
				"notification" : {
				  "body" : "This is an FCM notification message!",
				  "title" : "FCM Message",
				  }
			   }
			}
		"""
        
        let request = CURLRequest(
            "https://fcm.googleapis.com/fcm/send",
            .addHeader(.authorization, "key=\(Schemes.Firebase.serverKey)"),
            .addHeader(.contentType, "application/json"),
            .httpMethod(.post),
            .postString(message)
        )
        request.perform { (confirmation) in
            do {
                let resp = try confirmation()
                Logger.d(resp.responseCode)
				Logger.d(resp.bodyString)
            } catch let error as CURLResponse.Error {
                Logger.d("Curl error " + error.localizedDescription, event: .e)
            } catch {
                Logger.d(error.localizedDescription, event: .e)
            }
        }
        
    }
}
