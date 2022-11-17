//
//  FriendsDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol FriendsDao {
    func isUserFriends(loggedUserID: Int,visitingUserID: Int) -> Bool
    func getIDsOfFriends(userID: Int) -> Set<Int>
    func getUserFriends(userID: Int) -> [String]
}
