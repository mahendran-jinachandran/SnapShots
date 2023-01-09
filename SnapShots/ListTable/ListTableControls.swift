//
//  ListTableControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/01/23.
//

import Foundation

class ListTableControls: ListTableProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var blockedUserDaoImp: BlockedUserDao = BlockedUserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func getBlockedUsers() -> [User] {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return blockedUserDaoImp.getBlockedUsers(userID: loggedUserID)
    }
    
    func unblockTheUser(unblockingUserID: Int) -> Bool {
        
        return blockedUserDaoImp.unblockTheUser(unblockingUserID: unblockingUserID)
    }
}
