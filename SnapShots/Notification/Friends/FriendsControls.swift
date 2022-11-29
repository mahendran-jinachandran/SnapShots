//
//  FriendsControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import Foundation
import UIKit

class FriendsControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    
    func getAllFriends() -> [(userDP: UIImage,username: String)] {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendsDaoImp.getUserFriends(userID: userID)
    }
}
