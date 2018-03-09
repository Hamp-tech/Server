//
//  HampySMTP.swift
//  ServerPackageDescription
//
//  Created by Joan Molinas Ramon on 16/2/18.
//

import PerfectSMTP

struct HampySMTP {
    
    // MARK: - Properties
    private static let sharedClient = SMTPClient(url: "smtps://smtp.gmail.com", username: "joanmramon@gmail.com", password: "")
    
    static func foo() {
        let email = EMail(client: sharedClient)
        email.subject = "Test mail"
        
        email.from = Recipient(name: "Joan Molinas", address: "joanmramon@gmail.com")
        
        email.content = "This is a test mail"
        
        email.to.append(Recipient(name: "Joan 2", address: "joan@finteca.es"))
        
        do {
            try email.send(completion: { (code, header, body) in
                Logger.d(code)
                Logger.d(header)
                Logger.d(body)
            })
        } catch {
            Logger.d(error.localizedDescription, event: .e)
        }
    }
    
}
