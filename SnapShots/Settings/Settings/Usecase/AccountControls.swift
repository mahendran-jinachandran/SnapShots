//
//  AccountControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import Foundation

class AccountControls: AccountControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func getUserDetails() -> User {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.getUserDetails(userID: loggedUserID)!
    }
    
    func updateEmail(email: String) -> Bool {
        return AppUtility.updateEmail(email: email)
    }
    
    func updateGender(gender: String) -> Bool {
        return AppUtility.updateGender(gender: gender)
    }
    
    func updateBirthday(birthday: String) -> Bool {
        return AppUtility.updateBirthday(birthday: birthday)
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Result<Bool,PhoneNumberError> {
        return AppUtility.validatePhoneNumber(phoneNumber: phoneNumber)
    }
    
    func updatePhoneNumber(phoneNumber: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.updatePhoneNumber(phoneNumber: phoneNumber, userID: loggedUserID)
    }
    
    func deleteAccount() -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.deleteAccount(userID: loggedUserID)
    }
}
