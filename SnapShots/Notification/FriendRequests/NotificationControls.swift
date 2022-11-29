//
//  NotificationControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import Foundation
import UIKit

class NotificationControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendRequestDaoImp: FriendRequestDao = FriendRequestDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    
    func getAllFriendRequests() -> [(userId: Int, userName: String,userDP: UIImage)] {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendRequestDaoImp.getRequestedFriendsList(userID: userID)
    }
    
    func acceptFriendRequest(acceptingUserID: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        return friendRequestDaoImp.acceptFriendRequest(loggedUserID: userID, friendRequestedUser: acceptingUserID)
    }
}
