//
//  ForgotPasswordControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import Foundation

class ForgotPasswordControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func updatePassword(phoneNumber: String,password: String) {
        
        _ =  userDaoImp.updatePassword(password: password, phoneNumber: phoneNumber) 
    }
}
