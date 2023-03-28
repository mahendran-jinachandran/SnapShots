//
//  LoginAssembler.swift
//  SnapShots
//
//  Created by mahendran-14703 on 27/03/23.
//

import Foundation

class LoginAssembler {
    
    static let shared = LoginAssembler()
    
    @objc func configure() -> LoginVC {
        let loginDatabaseService = LoginDatabaseService()
        let dataManager = LoginDataManager(localService: loginDatabaseService)
        return LoginVC(
            presenter: LoginPresenter(
                getLoginUseCase: LoginUsecase(dataManager: dataManager),
                router: LoginRouter()
            )
        )
    }
}
