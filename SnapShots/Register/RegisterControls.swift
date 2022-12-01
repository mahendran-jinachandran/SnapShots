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
            // MARK: TOAST CREATED USER
            
        } else {
            // MARK: TOAST COULD NOT CREATE USER
        }
    }
    
    func validateUsername(username: String) -> Result<Bool,UsernameError> {
        
        let isValidUsername = AppUtility.isValidUsername(username: username)
        
        guard let _ = try? isValidUsername.get() else {
            return isValidUsername
        }
        

        let isUsernameTaken = userDaoImp.isUsernameAlreadyExist(username: username)
        return .success(!isUsernameTaken)
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Result<Bool,PhoneNumberError> {
        
        let isValidPhoneNumber = AppUtility.isValidPhoneNumber(phoneNumber: phoneNumber)
        
        guard let _ = try? isValidPhoneNumber.get() else {
            return isValidPhoneNumber
        }
        
        let isPhoneNumberTaken = userDaoImp.isPhoneNumberAlreadyExist(phoneNumber: phoneNumber)
        return .success(!isPhoneNumberTaken)
    }
}
