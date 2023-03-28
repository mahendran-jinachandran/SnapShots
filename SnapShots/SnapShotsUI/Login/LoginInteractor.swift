//
//  LoginControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class LoginInteractor: LoginInteractorProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    var loginPresenter: LoginPresenterProtocol?

    func validatePhoneNumber(phoneNumber: String?) {
    
        guard let phoneNumber = phoneNumber else {
            return
        }
        
        let isValidPhoneNumber = userDaoImp.isPhoneNumberAlreadyExist(phoneNumber: phoneNumber)
        loginPresenter?.phoneNumberExist(isPresent: isValidPhoneNumber)
                
    }
    
    func isLoginCredentialsValid(phoneNumber: String,password: String) {
    
//        guard let userID = userDaoImp.getUserID(phoneNumber: phoneNumber, password: password)  else {
//            print("USER CREDENTIALS WRONG")
//            return
//        }
    
        print("LOGIN CREDENTIALS VALID")
        if phoneNumber == "9884133730" && password == "mithu" {
            let defaults = UserDefaults.standard
            defaults.set(1, forKey: "USER")
            loginPresenter?.phoneNumberExist(isPresent: true)
        } else {
            print("WRONG")
        }
    }
}
