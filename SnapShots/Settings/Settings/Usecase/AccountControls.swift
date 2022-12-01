//
//  AccountControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import Foundation

class AccountControls {
    
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
        
        if userDaoImp.updateMail(mailID: email, userID: loggedUserID) {
            // MARK: EMAIL IS UPDATED
        } else {
            // MARK: COULDN'T UPDATE
        }
        
        return true
    }
    
    func updateGender(gender: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if userDaoImp.updateGender(gender: gender, userID: loggedUserID) {
            // MARK: GENDER IS UPDATED
            return true
        } else {
            // MARK: COULDN'T UPDATE
            return false
        }
    }
    
    func updateBirthday(birthday: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if userDaoImp.updateAge(age: birthday, userID: loggedUserID) {
            // MARK: AGE IS UPDATED
            return true
        } else {
            // MARK: COULDN'T UPDATE
            return false
        }
    }
}
