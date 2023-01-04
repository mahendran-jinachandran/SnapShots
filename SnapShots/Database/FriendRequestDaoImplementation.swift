//
//  FriendRequestDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//


import Foundation
import UIKit

class FriendRequestDaoImplementation: FriendRequestDao {

    private let TABLE_NAME = "FriendRequest"
    private let REQUESTED_ID = "Requested_id"
    private let USER_ID = "User_id"
    
    private let sqliteDatabase: DatabaseProtocol
    private let userDaoImplementation: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImplementation: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImplementation = userDaoImplementation
    }
    
    func getRequestedFriendsList(userID: Int) -> [User] {
        let getFriendRequestsQuery = """
        SELECT \(REQUESTED_ID)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        """
        
        var requestFriends: [User] = []
        for (_,userID) in sqliteDatabase.retrievingQuery(query: getFriendRequestsQuery) {
            requestFriends.append(
                userDaoImplementation.getUserDetails(userID: Int(userID[0])!)!
            )
        }
        
        return requestFriends
    }
    
    func acceptFriendRequest(loggedUserID: Int,friendRequestedUser: Int) -> Bool {
        
        let acceptFriendRequestForRequestedUserQuery = """
        INSERT INTO Friends
        VALUES (\(friendRequestedUser),\(loggedUserID));
        """

        let acceptFriendRequestForAcceptingUserQuery = """
        INSERT INTO Friends
        VALUES (\(loggedUserID),\(friendRequestedUser));
        """
        
        return removeFriendRequest(removingUserID: loggedUserID, profileUserID: friendRequestedUser) &&
        removeFriendRequest(removingUserID: friendRequestedUser, profileUserID: loggedUserID) &&
        sqliteDatabase.execute(query: acceptFriendRequestForAcceptingUserQuery) && sqliteDatabase.execute(query: acceptFriendRequestForRequestedUserQuery)
    }
    
    func removeFriendRequest(removingUserID: Int,profileUserID: Int) -> Bool {
        let rejectFriendRequestQuery = """
        DELETE FROM \(TABLE_NAME)
        WHERE \(REQUESTED_ID) = \(profileUserID)
        AND \(USER_ID) = \(removingUserID);
        """
        
        return sqliteDatabase.execute(query: rejectFriendRequestQuery)
    }
    
    
    func sendFriendRequest(loggedUserID: Int,visitingUserID: Int) -> Bool {
        let addFriendRequestQuery = """
        INSERT INTO \(TABLE_NAME)
        VALUES (\(visitingUserID),\(loggedUserID));
        """
        
        return sqliteDatabase.execute(query: addFriendRequestQuery)
    }
    
    func cancelFriendRequest(loggedUserID: Int) -> Bool {
        let cancelFriendRequestQuery = """
        DELETE FROM \(TABLE_NAME)
        WHERE \(REQUESTED_ID) = \(loggedUserID);
        """

        return sqliteDatabase.execute(query: cancelFriendRequestQuery)
    }
    
    func isAlreadyRequestedFriend(loggedUserID: Int,visitingUserID: Int) -> Bool {
        let isAlreadyRequestedFriend = """
        SELECT * FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(visitingUserID)
        AND \(REQUESTED_ID) = \(loggedUserID);
        """
        
        return !sqliteDatabase.retrievingQuery(query: isAlreadyRequestedFriend).isEmpty
    }
}
