//
//  PostControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class PostControls: PostControlsProtocol {

    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func deletePost(postID: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        UIImage().deleteImage(imageName: "\(userID)\(Constants.postSavingFormat)\(postID)")
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
    
    func getAllComments(postUserID: Int,postID: Int) -> [CommentDetails] {
        return commentsDaoImp.getAllCommmentsOfPost(postUserID: postUserID, postID: postID)
    }
    
    func addComment(postUserID: Int,postID: Int,comment: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return commentsDaoImp.addCommentToThePost(visitingUserID: postUserID, postID: postID, comment: comment, loggedUserID: loggedUserID)
    }
    
    func removeFriend(profileRequestedUser: Int) -> Bool {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendsDaoImp.removeFriend(loggedUserID: userID, removingUserID: profileRequestedUser)
    }
    
    func hideLikesCount(userID: Int, postID: Int) {
        _ = postDaoImp.hideLikesInPost(userID: userID, postID: postID)
    }
    
    func unhideLikesCount(userID: Int, postID: Int) {
        _ = postDaoImp.unhideLikesInPost(userID: userID, postID: postID)
    }
    
    func getLikesButtonVisibilityState(userID: Int,postID: Int) -> Bool {
        return postDaoImp.getLikesButtonVisibilityState(userID: userID, postID: postID)
    }
    
    func hideComments(userID: Int, postID: Int) {
        _ = postDaoImp.hideCommentsInPost(userID: userID, postID: postID)
    }
    
    func unhideComments(userID: Int, postID: Int) {
        _ = postDaoImp.unhideCommentsInPost(userID: userID, postID: postID)
    }
    
    func getCommentsButtonVisibilityState(userID: Int,postID: Int) -> Bool {
        return postDaoImp.getCommentsButtonVisibilityState(userID: userID, postID: postID)
    }
    
    func hasSpecialPermissions(postUserID: Int) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return loggedUserID == postUserID
    }
    
    func deleteComment(userID: Int,postID: Int,commentID: Int) {
       _ = commentsDaoImp.deleteCommentFromThePost(userID: userID, postID: postID, commentID: commentID)
    }
}
