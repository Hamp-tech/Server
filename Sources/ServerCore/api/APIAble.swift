//
//  APIable.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//

import PerfectHTTP

protocol APIAble {
    func routes() -> Routes
}
