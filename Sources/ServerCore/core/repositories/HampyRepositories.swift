//
//  HampyRepositories.swift
//  Server-SwiftPackageDescription
//
//  Created by Joan Molinas Ramon on 25/1/18.
//

import Foundation
import MongoKitten

class HampyRepositories {
    
    // MARK: - Properties
    private let database: Database
    let usersRepository: HampyRepository<HampyUser>
    let pointsRepository: HampyRepository<HampyPoint>
    let servicesRepository: HampyRepository<HampyService>
    let bookingRepository: HampyRepository<HampyBooking>
    let transactionsRepository: HampyRepository<HampyTransaction>
    
    // MARK: - Life cycle
    init(database: Database) {
        self.database = database
        self.usersRepository = HampyUsersRepository(database: database)
        self.pointsRepository = HampyPointsRepository(database: database)
        self.servicesRepository = HampyServicesRespository(database: database)
        self.bookingRepository = HampyBookingRepository(database: database)
        self.transactionsRepository = HampyTransactionsRepository(database: database)
    }
    
    func close() {
        usersRepository.close()
        pointsRepository.close()
        servicesRepository.close()
        bookingRepository.close()
        transactionsRepository.close()
    }
}
