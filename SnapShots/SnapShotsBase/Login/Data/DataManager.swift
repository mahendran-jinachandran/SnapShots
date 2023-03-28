//
//  DataManager.swift
//  SnapShots
//
//  Created by mahendran-14703 on 27/03/23.
//

import Foundation

class LoginDataManager{
    
    private let localService: LoginDatabaseService
    
    init(localService: LoginDatabaseService) {
        self.localService = localService
    }
    
    func isValidUser(
        phoneNumber: String?,
        password: String?,
        completion: @escaping (Result<Bool,AuthenticationError>) -> Void
    ) {
        localService.isLoginAuthenticated(
            phoneNumber: phoneNumber,
            password: password,
            completion: completion
        )
    }
}
