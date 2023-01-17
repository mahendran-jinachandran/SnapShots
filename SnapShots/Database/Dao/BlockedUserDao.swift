//
//  BlockedUserDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/01/23.
//

import Foundation

protocol BlockedUserDao {
    func blockUser(loggedUserID: Int,userID: Int) -> Bool
    func getBlockedUsers(userID: Int) -> [User]
    func unblockTheUser(unblockingUserID: Int) -> Bool
    func isBlocked(userID: Int,loggedUserID: Int) -> Bool
    func getBlockedUser(rowID: Int) -> Int
}
