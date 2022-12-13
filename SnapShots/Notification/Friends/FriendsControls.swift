//
//  FriendsControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import Foundation

class FriendsControls: FriendsControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    
    func getAllFriends(userID: Int) -> [User] {
        var friends: [User] = []
        
        for userID in friendsDaoImp.getIDsOfFriends(userID: userID) {
            friends.append(
                userDaoImp.getUserDetails(userID: userID)!
            )
        }

        return friends
    }
}
