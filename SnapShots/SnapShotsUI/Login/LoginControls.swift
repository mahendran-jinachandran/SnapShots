//
//  LoginController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 17/11/22.
//

import Foundation

//class LoginControls: LoginControllerProtocol {
//
//    private weak var loginView: LoginViewProtocol?
//    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
//
//    public func setView(_ loginView: LoginViewProtocol) {
//        self.loginView = loginView
//    }
//
//    func validatePhoneNumber(phoneNumber: String) {
//        let isPhoneNumberPresent = userDaoImp.isPhoneNumberAlreadyExist(phoneNumber: phoneNumber)
//        loginView?.displayPhoneNumberVerificationState(isVerified: isPhoneNumberPresent)
//    }
//
//    func validateUserCredentials(phoneNumber: String,password: String) {
//        
//        guard let userID = userDaoImp.getUserID(phoneNumber: phoneNumber, password: password) else {
//            loginView?.displayWrongCredentials()
//            return
//        }
//
//        UserDefaults.standard.set(userID, forKey: Constants.loggedUserFormat)
//        loginView?.goToHomePage()
//    }
//}
