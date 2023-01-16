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
    private let USER_TABLE_NAME = "User"
    private let USER_ID = "User_id"
    private let FRIENDS_ID = "Friends_id"
    private let BLOCKED_USER_ID = "BlockedUser_id"
    private let BLOCKED_USERS_TABLE_NAME = "BlockedUsers"
    
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
    
    func getIDsOfFriends(userID: Int) -> [Int] {
        let getFriendIDsQuery = """
        SELECT \(FRIENDS_ID)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID) AND
        \(FRIENDS_ID) NOT IN
        (SELECT \(BLOCKED_USER_ID) FROM \(BLOCKED_USERS_TABLE_NAME) WHERE \(USER_ID) = \(userID))
        ;
        """
        
        var myFriendIDs: [Int] = []
        for (_,userID) in sqliteDatabase.retrievingQuery(query: getFriendIDsQuery) {
            myFriendIDs.append(Int(userID[0])!)
        }
            
        return myFriendIDs
    }
    
    func getUserFriends(userID: Int) -> [(userDP: UIImage,username: String)] {
        
        var myFriends: [(userDP: UIImage,username: String)] = []
        for friendID in getIDsOfFriends(userID: userID) {
            
            let userDP = AppUtility.getDisplayPicture(userID: friendID)
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
    
    func getFriendID(rowID: Int) -> Int {
        let getFriendIDQuery = """
        SELECT \(FRIENDS_ID) FROM \(TABLE_NAME)
        WHERE rowid = \(rowID);
        """
        
        let friendDetail = sqliteDatabase.retrievingQuery(query: getFriendIDQuery)
        return Int(friendDetail[1]![0])!
    }
}

