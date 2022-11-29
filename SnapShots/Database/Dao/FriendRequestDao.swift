//
//  FriendRequestDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation
import UIKit

protocol FriendRequestDao {
    func getRequestedFriendsList(userID: Int) -> [(userId: Int, userName: String,userDP: UIImage)]
    func acceptFriendRequest(loggedUserID: Int,friendRequestedUser: Int) -> Bool
    func removeFriendRequest(loggedUserID: Int,userID: Int) -> Bool
    func sendFriendRequest(loggedUserID: Int,visitingUserID: Int) -> Bool
    func cancelFriendRequest(loggedUserID: Int) -> Bool
    func isAlreadyRequestedFriend(loggedUserID: Int,visitingUserID: Int) -> Bool
}
