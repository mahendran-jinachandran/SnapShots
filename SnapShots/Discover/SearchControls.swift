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
        
        var users = userDaoImp.getAllUsers()
        
        users = users.sorted(by: {
            $0.userName.compare($1.userName) == .orderedAscending
        })
        
        return users
    }
    
    func getUser(userID: Int) -> User {
        return userDaoImp.getUserDetails(userID: userID)!
    }
}
