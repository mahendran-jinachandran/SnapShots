//
//  SearchControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import UIKit

class SearchControls: SearchControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func getAllUsers() -> [User] {
        return userDaoImp.getAllUsers()
    }
}
