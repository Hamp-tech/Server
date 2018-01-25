//
//  HampyRepositories.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation
import PerfectMongoDB

class HampyRepositories {
    
    // MARK: - Properties
    private let mongoDatabase: MongoDatabase
    let usersRepository: HampyUsersRepository
    let pointsRepository: HampyPointsRepository
    let servicesRepository: HampyServicesRespository
    
    // MARK: - Life cycle
    init(mongoDatabase: MongoDatabase) {
        self.mongoDatabase = mongoDatabase
        self.usersRepository = HampyUsersRepository(mongoDatabase: mongoDatabase)
        self.pointsRepository = HampyPointsRepository(mongoDatabase: mongoDatabase)
        self.servicesRepository = HampyServicesRespository(mongoDatabase: mongoDatabase)
    }
}
