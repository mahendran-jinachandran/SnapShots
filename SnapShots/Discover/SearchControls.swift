//
//  SearchControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import Foundation
import UIKit

class SearchControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func getAllUsers() -> [(user: User,userDP: UIImage)] {
        
        var users: [(user: User,userDP: UIImage)] = []
        for user in userDaoImp.getAllUsers() {
            
            var userDP: UIImage? = UIImage().loadImageFromDiskWith(fileName: "\(Constants.dpSavingFormat)\(user.userID)")
            
            if userDP == nil {
                userDP = UIImage().loadImageFromDiskWith(fileName: "ProfileDP")
            }
            
            users.append((
                user,
                userDP!
            ))
        }
        
        return users
    }
}
