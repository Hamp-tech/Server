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
    let usersRepository: HampyRepository<HampyUser>
    let pointsRepository: HampyRepository<HampyPoint>
    let servicesRepository: HampyRepository<HampyService>
    let bookingRepository: HampyRepository<HampyBooking>
    let transactionsRepository: HampyRepository<HampyTransaction>
    
    // MARK: - Life cycle
    init(mongoDatabase: MongoDatabase) {
        self.mongoDatabase = mongoDatabase
        self.usersRepository = HampyUsersRepository(mongoDatabase: mongoDatabase)
        self.pointsRepository = HampyPointsRepository(mongoDatabase: mongoDatabase)
        self.servicesRepository = HampyServicesRespository(mongoDatabase: mongoDatabase)
        self.bookingRepository = HampyBookingRepository(mongoDatabase: mongoDatabase)
        self.transactionsRepository = HampyTransactionsRepository(mongoDatabase: mongoDatabase)
    }
    
    func close() {
        usersRepository.close()
        pointsRepository.close()
        servicesRepository.close()
        bookingRepository.close()
        transactionsRepository.close()
    }
}
