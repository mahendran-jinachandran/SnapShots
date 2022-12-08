//
//  PostControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class PostControls: PostControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImplementation: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImplementation)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func deletePost(postID: Int) {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        if postDaoImp.deletePost(userID: userID, postID: postID) {
            print("Deleted")
            // MARK: SHOW THAT POST IS DELETED
        } else {
            print("Not Deleted")
            // MARK: SHOW THAT POST IS NOT DELETED
        }
    }
    
    func addLikeToThePost(postUserID: Int,postID: Int) -> Bool {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return likesDaoImp.addLikeToThePost(loggedUserID: loggedUser, visitingUserID: postUserID, postID: postID)
    }
    
    func removeLikeFromThePost(postUserID: Int,postID: Int) -> Bool {
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        return likesDaoImp.removeLikeFromThePost(loggedUserID: loggedUser, visitingUserID: postUserID, postID: postID)
    }
    
    func isAlreadyLikedThePost(postUserID: Int,postID: Int) -> Bool {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return likesDaoImp.isPostAlreadyLiked(loggedUserID: loggedUser, visitingUserID: postUserID, postID: postID)
    }
    
    func getUsername(userID: Int) -> String {
        return userDaoImp.getUsername(userID: userID)
    }
    
    func getPostImage(postImageName: String) -> UIImage {
        return UIImage().loadImageFromDiskWith(fileName: postImageName)!
    }
    
    func getUserDP(userID: Int) -> UIImage {
        return AppUtility.getDisplayPicture(userID: userID)
    }
}
