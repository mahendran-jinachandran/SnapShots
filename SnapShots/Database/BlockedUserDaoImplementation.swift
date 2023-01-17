//
//  BlockedUserDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/01/23.
//

import Foundation

class BlockedUserDaoImplementation: BlockedUserDao {
    
    private let BLOCKED_USERS_TABLE_NAME = "BlockedUsers"
    private let BLOCKED_USER_ID = "BlockedUser_id"
    private let USER_ID = "User_id"
    
    private let sqliteDatabase: DatabaseProtocol
    private let userDaoImp: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImp: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImp = userDaoImp
    }
    
    func blockUser(loggedUserID: Int,userID: Int) -> Bool {
        
        let blockUser = """
        INSERT INTO \(BLOCKED_USERS_TABLE_NAME)
        VALUES (\(loggedUserID),\(userID));
        """
        
        return sqliteDatabase.execute(query: blockUser)
    }
    
    func getBlockedUsers(userID: Int) -> [User] {
        
        let blockedUsersQuery = """
        SELECT \(BLOCKED_USER_ID)
        FROM \(BLOCKED_USERS_TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        """
        
        var blockedUsers = [User]()
        for id in sqliteDatabase.retrievingQuery(query: blockedUsersQuery) {
            blockedUsers.append(
                userDaoImp.getUserDetails(userID: Int(id.value[0])!)!
            )
        }
        
        return blockedUsers
    }
    
    func unblockTheUser(unblockingUserID: Int) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        let unblockUserQuery = """
        DELETE FROM \(BLOCKED_USERS_TABLE_NAME)
        WHERE \(USER_ID) = \(loggedUserID) AND
        \(BLOCKED_USER_ID) = \(unblockingUserID)
        """
        
        return sqliteDatabase.execute(query: unblockUserQuery)
    }
    
    func isBlocked(userID: Int,loggedUserID: Int) -> Bool {
        
        var isBlockedQuery = """
        SELECT \(BLOCKED_USER_ID) FROM
        \(BLOCKED_USERS_TABLE_NAME) WHERE
        \(USER_ID) = \(loggedUserID)
        """
        
        for user in sqliteDatabase.retrievingQuery(query: isBlockedQuery) {
            if Int(user.value[0])! == userID {
                return true
            }
        }
        
        isBlockedQuery = """
        SELECT \(BLOCKED_USER_ID) FROM
        \(BLOCKED_USERS_TABLE_NAME) WHERE
        \(USER_ID) = \(userID)
        """
        
        for user in sqliteDatabase.retrievingQuery(query: isBlockedQuery) {
            if Int(user.value[0])! == loggedUserID {
                return true
            }
        }
        
        return false
    }
    
    func getBlockedUser(rowID: Int) -> Int {
        let getBlockedUserQuery = """
        SELECT \(BLOCKED_USER_ID) FROM
        \(BLOCKED_USERS_TABLE_NAME)
        WHERE rowid = \(rowID);
        """
        
        let data = sqliteDatabase.retrievingQuery(query: getBlockedUserQuery)
        return Int(data[1]![0])!
    }
}
