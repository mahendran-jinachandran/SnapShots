//
//  AccountControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import Foundation

class AccountControls: AccountControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func getuserDetails() -> User {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.getUserDetails(userID: loggedUserID)!
    }
    
    func updateEmail(email: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if !AppUtility.isValidEmail(email){
            return false
        }
        
        return userDaoImp.updateMail(mailID: email, userID: loggedUserID)
   
    }
    
    func updateGender(gender: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.updateGender(gender: gender, userID: loggedUserID)
    }
    
    func updateBirthday(birthday: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.updateAge(age: birthday, userID: loggedUserID)
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Result<Bool,PhoneNumberError> {
        
        let isValidPhoneNumber = AppUtility.isValidPhoneNumber(phoneNumber: phoneNumber)
        
        guard let _ = try? isValidPhoneNumber.get() else {
            return isValidPhoneNumber
        }
        
        let isPhoneNumberTaken = userDaoImp.isPhoneNumberAlreadyExist(phoneNumber: phoneNumber)
        return .success(!isPhoneNumberTaken)
    }
    
    func updatePhoneNumber(phoneNumber: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.updatePhoneNumber(phoneNumber: phoneNumber, userID: loggedUserID)
    }
}
