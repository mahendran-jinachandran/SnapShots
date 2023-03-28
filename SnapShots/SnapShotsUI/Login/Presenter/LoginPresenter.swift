//
//  LoginPresenter.swift
//  SnapShots
//
//  Created by mahendran-14703 on 27/03/23.
//

import Foundation

class LoginPresenter {
    
    private let getLoginUsecase: LoginUsecase
    private let router: LoginRouter
    @Observable private(set) var errorUser: AuthenticationError? // OBSERVABLE
    
    init(
        getLoginUseCase: LoginUsecase,
        router: LoginRouter
    ) {
        self.getLoginUsecase = getLoginUseCase
        self.router = router
    }
    
    func validateLogin(phoneNumber: String?,password: String?) {
        
        let loginRequest = LoginRequest(
            phoneNumber: phoneNumber,
            password: password
        )
    
        getLoginUsecase.execute(request: loginRequest) { [weak self] result in
           
                guard let self else { return }
                
                if case let Result.failure(error) = result {
                    self.errorUser = error
                    return
                }
                
                let loginResponse = try! result.get()
                if loginResponse.isValidUser {
                    self.router.routeToHomePage()
                }
        }
    }
}
