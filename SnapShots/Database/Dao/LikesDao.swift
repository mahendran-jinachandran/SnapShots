//
//  LikesDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol LikesDao {
    func isPostAlreadyLiked(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool
    func addLikeToThePost(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool
    func removeLikeFromThePost(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool
    func getAllLikesOfPost(userID: Int,postID: Int) -> [User]
}
