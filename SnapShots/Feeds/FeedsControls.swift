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
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func getAllPosts() -> [FeedsDetails] {
        
        var feedPosts: [FeedsDetails] = []
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        for (userID,username,postDetails) in postDaoImp.getAllFriendPosts(userID: loggedUserID) {
            
            feedPosts.append(FeedsDetails(
                userID: userID,
                userName: username,
                postDetails: postDetails)
            )
        }
        
        return feedPosts
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
        return postDaoImp.deletePost(userID: userID, postID: postID)
    }
}
