//
//  MongoDriver.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 8/12/17.
//
import PerfectMongoDB

internal class HampyMongo {
    // MARK: - Properties
    let database: String
    private(set) var client: MongoClient?
    
    
    // MARK: - Constructor
    init(database: String) {
        self.database = database
    }
    
    // MARK: - API
    func open() {
        client = try? MongoClient(uri: "localhost://mongodb")
    }
    
    func close() {
        client?.close()
    }
}
