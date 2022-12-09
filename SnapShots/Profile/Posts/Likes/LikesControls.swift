//
//  LikesControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 06/12/22.
//

import UIKit

class LikesControls: LikesControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var likeDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func getAllLikedUsers(postUserID: Int,postID: Int) -> [User] {
        return likeDaoImp.getAllLikesOfPost(userID: postUserID, postID: postID)
    }
}
