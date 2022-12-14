//
//  FriendsDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation
import UIKit

class FriendsDaoImplementation: FriendsDao {

    private let TABLE_NAME = "Friends"
    private let USER_ID = "User_id"
    private let FRIENDS_ID = "Friends_id"
    
    private let sqliteDatabase: DatabaseProtocol
    private let userDaoImplementation: UserDao
    
    init(sqliteDatabase: DatabaseProtocol,userDaoImplementation: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImplementation = userDaoImplementation
    }
    
    func isUserFriends(loggedUserID: Int,visitingUserID: Int) -> Bool {
        
        let isUserFriendsQuery = """
        SELECT * FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(loggedUserID)
        AND \(FRIENDS_ID) = \(visitingUserID);
        """
        
        return !sqliteDatabase.retrievingQuery(query: isUserFriendsQuery).isEmpty
    }
    
    func getIDsOfFriends(userID: Int) -> Set<Int> {
        let getFriendIDsQuery = """
        SELECT \(FRIENDS_ID)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID);
        """
        
        var myFriendIDs: Set<Int> = []
        for (_,userID) in sqliteDatabase.retrievingQuery(query: getFriendIDsQuery) {
            myFriendIDs.insert(Int(userID[0])!)
        }
        
        return myFriendIDs
    }
    
    func getUserFriends(userID: Int) -> [(userDP: UIImage,username: String)] {
        
        var myFriends: [(userDP: UIImage,username: String)] = []
        for friendID in getIDsOfFriends(userID: userID) {
            
            var userDP = AppUtility.getDisplayPicture(userID: friendID)
            myFriends.append(
                (userDP,
                 userDaoImplementation.getUsername(userID: friendID)
                )
            )
        }
    
        return myFriends
    }
    
    func removeFriend(loggedUserID: Int, removingUserID: Int) -> Bool {
        
        let removingFriendRequestRemovingUserQuery = """
        DELETE FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(loggedUserID)
        AND \(FRIENDS_ID) = \(removingUserID);
        """
        
        let removingFriendRequestRequestedUserQuery = """
        DELETE FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(removingUserID)
        AND \(FRIENDS_ID) = \(loggedUserID);
        """
        
        return sqliteDatabase.execute(query: removingFriendRequestRemovingUserQuery) && sqliteDatabase.execute(query: removingFriendRequestRequestedUserQuery)
        
    }
}

