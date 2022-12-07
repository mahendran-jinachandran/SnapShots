//
//  SearchControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import UIKit

class SearchControls: SearchControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func getAllUsers() -> [(user: User,userDP: UIImage)] {
        
        var users: [(user: User,userDP: UIImage)] = []
        for user in userDaoImp.getAllUsers() {
            
            var userDP = AppUtility.getDisplayPicture(userID: user.userID)
            users.append((
                user,
                userDP
            ))
        }
        
        return users
    }
}
