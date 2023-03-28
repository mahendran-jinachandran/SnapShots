//
//  LoginUseCase.swift
//  SnapShots
//
//  Created by mahendran-14703 on 27/03/23.
//

import Foundation

final class LoginRequest {
    let phoneNumber: String?
    let password: String?
    
    init(phoneNumber: String?, password: String?) {
        self.phoneNumber = phoneNumber
        self.password = password
    }
}

final class LoginResponse {
    let isValidUser: Bool
    
    init(isValidUser: Bool) {
        self.isValidUser = isValidUser
    }
}

class LoginUsecase {
    
    private let dataManager: LoginDataManager
    
    init(dataManager: LoginDataManager) {
        self.dataManager = dataManager
    }
    
    func execute(request: LoginRequest,completion: @escaping (Result<LoginResponse,AuthenticationError>) -> Void) {
        
        dataManager.isValidUser(
            phoneNumber: request.phoneNumber,
            password: request.password
        ) { result in
            
            if case let Result.failure(error) = result {
                return completion(.failure(error))
            }
            
            let isLoginValid = try! result.get()
            let loginReponse = LoginResponse(isValidUser: isLoginValid)
            completion(.success(loginReponse))
            
        }
    }
}
