//
//  SecurityController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 02/12/22.
//

import Foundation

class SecurityController {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func isPasswordCorrect(password: String) -> Bool {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let user = userDaoImp.getUserDetails(userID: userID)!

        return user.password == password
    }
    
    func updatePassword(password: String) {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        _ = userDaoImp.updatePassword(password: password, userID: userID)
    }
}
