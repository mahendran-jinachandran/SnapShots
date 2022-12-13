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
    
    func executeRegistrationProcess(username: String,phoneNumber: String,password: String) -> Bool {
        
        if !userDaoImp.createNewUser(userName: username, password: password, phoneNumber: phoneNumber) {
            return false
        }
        
        guard let userID = userDaoImp.getUserID(phoneNumber: phoneNumber, password: password) else {
            return false
        }
        
        UserDefaults.standard.set(userID, forKey: Constants.loggedUserFormat)
        return true
    }
    
    func validateUsername(username: String) -> Result<Bool,UsernameError> {
        return AppUtility.validateUsername(username: username)
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Result<Bool,PhoneNumberError> {
        return AppUtility.validatePhoneNumber(phoneNumber: phoneNumber)
    }
}
