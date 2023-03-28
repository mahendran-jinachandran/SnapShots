//
//  LoginDatabaseService.swift
//  SnapShots
//
//  Created by mahendran-14703 on 27/03/23.
//

import Foundation

class LoginDatabaseService {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)

    func isLoginAuthenticated(
        phoneNumber: String?,
        password: String?,
        completion: @escaping (Result<Bool,AuthenticationError>) -> Void
    ) {
        
        guard let phoneNumber else { return }

        if !userDaoImp.isPhoneNumberAlreadyExist(phoneNumber: phoneNumber) {
            completion(.failure(.doesNotExist(reason: "Phone Number is not registered")))
            return
        }
        
        guard let password else { return }
        
        if let userID = userDaoImp.getUserID(phoneNumber: phoneNumber, password: password) {
            UserDefaults.standard.set(userID, forKey: Constants.loggedUserFormat)
            completion(.success(true))
        } else {
            completion(.failure(.notAValidUser(reason: "User is not registered")))
        }
    }
}
