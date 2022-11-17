//
//  FriendsDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class FriendsDaoImplementation: FriendsDao {
    
    private let sqliteDatabase: DatabaseProtocol
    private let userDaoImplementation: UserDao
    
    init(sqliteDatabase: DatabaseProtocol,userDaoImplementation: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImplementation = userDaoImplementation
    }
    
    func isUserFriends(loggedUserID: Int,visitingUserID: Int) -> Bool {
        
        let isUserFriendsQuery = """
        SELECT * FROM Friends WHERE User_id = \(loggedUserID)
        AND Friends_id = \(visitingUserID);
        """
        
        return !sqliteDatabase.retrievingQuery(query: isUserFriendsQuery).isEmpty
    }
    
    func getIDsOfFriends(userID: Int) -> Set<Int> {
        let getFriendIDsQuery = """
        SELECT Friends_id FROM Friends WHERE User_id = \(userID);
        """
        
        var myFriendIDs: Set<Int> = []
        for (_,userID) in sqliteDatabase.retrievingQuery(query: getFriendIDsQuery) {
            myFriendIDs.insert(Int(userID[0])!)
        }
        
        return myFriendIDs
    }
    
    func getUserFriends(userID: Int) -> [String]  {
        
        var myFriendsNames: [String] = []
        
        for friendID in getIDsOfFriends(userID: userID) {
            myFriendsNames.append(userDaoImplementation.getUsername(userID: friendID) )
        }
    
        return myFriendsNames
    }
    
}

