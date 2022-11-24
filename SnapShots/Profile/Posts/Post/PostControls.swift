//
//  PostControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import Foundation

class PostControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImplementation: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImplementation)
    
    func deletePost(postID: Int) {
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        if postDaoImp.deletePost(userID: userID, postID: postID) {
            // MARK: SHOW THAT POST IS DELETED
        } else {
            // MARK: SHOW THAT POST IS NOT DELETED
        }
    }
}
