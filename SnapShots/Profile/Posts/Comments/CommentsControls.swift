//
//  CommentsControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 06/12/22.
//

import UIKit

class CommentsControls: CommentsControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared,userDaoImp: userDaoImp)
    
    func addComment(postUserID: Int,postID: Int,comment: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return commentsDaoImp.addCommentToThePost(visitingUserID: postUserID, postID: postID, comment: comment, loggedUserID: loggedUserID)
    }
    
    func getAllComments(postUserID: Int,postID: Int) -> [CommentDetails] {
        return commentsDaoImp.getAllCommmentsOfPost(postUserID: postUserID, postID: postID)
    }
    
    func deleteComment(userID: Int,postID: Int,commentID: Int) {
       _ = commentsDaoImp.deleteCommentFromThePost(userID: userID, postID: postID, commentID: commentID)
    }
    
    func hasSpecialPermissions(postUserID: Int) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return loggedUserID == postUserID
    }
}
