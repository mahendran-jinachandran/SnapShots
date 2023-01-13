//
//  FeedsControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class FeedsControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp,userDaoImp: userDaoImp,savedPostDaoImp: savedPostDaoImp)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var savedPostDaoImp: SavedPostsDao = SavedPostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func getAllPosts() -> [FeedsDetails] {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        let posts = postDaoImp.getAllFriendPosts(userID: loggedUserID)
        
        let feeds = posts.sorted(by: {
            $0.postDetails.postCreatedDate.compare($1.postDetails.postCreatedDate) == .orderedDescending
        })
        
        return feeds
    }
    
    func isAlreadyLikedThePost(postDetails: FeedsDetails) -> Bool {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return likesDaoImp.isPostAlreadyLiked(loggedUserID: loggedUser, visitingUserID: postDetails.userID, postID: postDetails.postDetails.postID)
    }
    
    func addLikeToThePost(postUserID: Int,postID: Int) -> Bool {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        return likesDaoImp.addLikeToThePost(loggedUserID: loggedUser, visitingUserID: postUserID, postID: postID)
    }
    
    func removeLikeFromThePost(postUserID: Int,postID: Int) -> Bool {
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        return likesDaoImp.removeLikeFromThePost(loggedUserID: loggedUser, visitingUserID: postUserID, postID: postID)
    }
    
    func isDeletionAllowed(userID: Int) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return loggedUserID == userID
    }
    
    func deletePost(postID: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        UIImage().deleteImage(imageName: "\(userID)\(Constants.postSavingFormat)\(postID)")
        return postDaoImp.deletePost(userID: userID, postID: postID)
    }
    
    func getAllLikedUsers(postUserID: Int,postID: Int) -> Int {
        return likesDaoImp.getAllLikesOfPost(userID: postUserID, postID: postID).count
    }
    
    func getAllComments(postUserID: Int,postID: Int) -> Int {
        return commentsDaoImp.getAllCommmentsOfPost(postUserID: postUserID, postID: postID).count
    }
    
    func removeFriend(profileRequestedUser: Int) -> Bool {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendsDaoImp.removeFriend(loggedUserID: userID, removingUserID: profileRequestedUser)
    }
    
    func addPostToSaved(postUserID: Int,postID: Int) -> Bool {
        return savedPostDaoImp.addPostToSaved(postUserID: postUserID, postID: postID)
    }
    
    func removePostFromSaved(postUserID: Int,postID: Int) -> Bool {
        return savedPostDaoImp.removePostFromSaved(postUserID: postUserID, postID: postID)
    }
    
    func isPostSaved(postUserID: Int,postID: Int) -> Bool {
        return savedPostDaoImp.isPostSaved(postUserID: postUserID, postID: postID)
    }
}
