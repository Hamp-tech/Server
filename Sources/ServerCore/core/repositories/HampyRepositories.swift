//
//  HampyRepositories.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation
import PerfectMongoDB
import MongoKitten

class HampyRepositories {
    
    // MARK: - Properties
    private let mongoDatabase: MongoDatabase
    private let database: Database
    let usersRepository: HampyRepository<HampyUser>
    let pointsRepository: HampyRepository<HampyPoint>
    let servicesRepository: HampyRepository<HampyService>
    let bookingRepository: HampyRepository<HampyBooking>
    let transactionsRepository: HampyRepository<HampyTransaction>
    
    // MARK: - Life cycle
    init(database: Database, mongoDatabase: MongoDatabase) {
        self.mongoDatabase = mongoDatabase
        self.database = database
        self.usersRepository = HampyUsersRepository(database: database, mongoDatabase: mongoDatabase)
        self.pointsRepository = HampyPointsRepository(database: database, mongoDatabase: mongoDatabase)
        self.servicesRepository = HampyServicesRespository(database: database, mongoDatabase: mongoDatabase)
        self.bookingRepository = HampyBookingRepository(database: database, mongoDatabase: mongoDatabase)
        self.transactionsRepository = HampyTransactionsRepository(database: database, mongoDatabase: mongoDatabase)
    }
    
    func close() {
        usersRepository.close()
        pointsRepository.close()
        servicesRepository.close()
        bookingRepository.close()
        transactionsRepository.close()
    }
}
