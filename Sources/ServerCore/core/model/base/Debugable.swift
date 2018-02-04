//
//  Debugable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 3/2/18.
//

import Foundation

protocol Debugable {
    func debug(_ message: Any,
               event: Logger.Event,
               fileName: String,
               line: Int,
               column: Int ,
               function: String)
}




