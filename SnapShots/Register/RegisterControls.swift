//
//  RegisterControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation

class RegisterControls: RegisterControllerProtocol {
    
    private var registerView: RegisterViewProtocol!
    
    public func setView(_ registerView: RegisterViewProtocol) {
        self.registerView = registerView
    }
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func executeRegistrationProcess(username: String,phoneNumber: String,password: String) {
        
        if userDaoImp.createNewUser(userName: username, password: password, phoneNumber: phoneNumber) {
            
            guard let userID = userDaoImp.getUserID(phoneNumber: phoneNumber, password: password) else {
                return
            }
            
            UserDefaults.standard.set(userID, forKey: Constants.loggedUserFormat)
            print("USER CREATED SUCCESSFULLY")
        } else {
            print("COULD NOT CREATE USER")
        }
    }
    
    func isUserNameTaken(username: String) -> Bool {
        return !userDaoImp.isUsernameAlreadyExist(username: username)
    }
    
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
        return !(userDaoImp.isPhoneNumberAlreadyExist(phoneNumber: phoneNumber))
                 
    }
}
