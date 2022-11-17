//
//  FriendRequestDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//


import Foundation

class FriendRequestDaoImplementation: FriendRequestDao {
    
    private let sqliteDatabase: DatabaseProtocol
    private let userDaoImplementation: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImplementation: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImplementation = userDaoImplementation
    }
    
    func getRequestedFriendsList(userID: Int) -> [(userId: Int, userName: String)] {
        let getFriendRequestsQuery = """
        SELECT Requested_id FROM FriendRequest WHERE User_id = \(userID)
        """
        
        var requestFriendIDs: Set<Int> = []
        for (_,userID) in sqliteDatabase.retrievingQuery(query: getFriendRequestsQuery) {
            requestFriendIDs.insert(Int(userID[0])!)
        }
        
        var requestedFriendDetails: [(userId: Int, userName: String)] = []
        
        for friendRequestID in requestFriendIDs {
            requestedFriendDetails.append((friendRequestID,userDaoImplementation.getUsername(userID: friendRequestID) ))
        }
        
        return requestedFriendDetails
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
        
        return sqliteDatabase.execute(query: acceptFriendRequestForAcceptingUserQuery) && sqliteDatabase.execute(query: acceptFriendRequestForRequestedUserQuery)
    }
    
    func removeFriendRequest(loggedUserID: Int,userID: Int) -> Bool {
        let rejectFriendRequestQuery = """
        DELETE FROM FriendRequest
        WHERE Requested_id = \(userID) AND User_id = \(loggedUserID);
        """
        
        return sqliteDatabase.execute(query: rejectFriendRequestQuery)
    }
    
    func sendFriendRequest(loggedUserID: Int,visitingUserID: Int) -> Bool {
        let addFriendRequestQuery = """
        INSERT INTO FriendRequest
        VALUES (\(visitingUserID),\(loggedUserID));
        """
        
        return sqliteDatabase.execute(query: addFriendRequestQuery)
    }
    
    func cancelFriendRequest(loggedUserID: Int) -> Bool {
        let cancelFriendRequestQuery = """
        DELETE FROM FriendRequest
        WHERE Requested_id = \(loggedUserID);
        """
        
        return sqliteDatabase.execute(query: cancelFriendRequestQuery)
    }
    
    func isAlreadyRequestedFriend(loggedUserID: Int,visitingUserID: Int) -> Bool {
        let isAlreadyRequestedFriend = """
        SELECT * FROM FriendRequest WHERE User_id = \(visitingUserID)
        AND Requested_id = \(loggedUserID);
        """
        
        return !sqliteDatabase.retrievingQuery(query: isAlreadyRequestedFriend).isEmpty
    }
}
