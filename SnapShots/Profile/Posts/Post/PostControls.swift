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
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func deletePost(postID: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return postDaoImp.deletePost(userID: userID, postID: postID)
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
    
    func isDeletionAllowed(userID: Int) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return loggedUserID == userID
    }
    
    func getAllLikedUsers(postUserID: Int,postID: Int) -> Int {
        return likesDaoImp.getAllLikesOfPost(userID: postUserID, postID: postID).count
    }
    
    func getAllComments(postUserID: Int,postID: Int) -> Int {
        return commentsDaoImp.getAllCommmentsOfPost(postUserID: postUserID, postID: postID).count
    }
}
