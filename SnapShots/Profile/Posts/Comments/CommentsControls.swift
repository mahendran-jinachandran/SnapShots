//
//  CommentsControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 06/12/22.
//

import UIKit

class CommentsControls: CommentsControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func addComment(postUserID: Int,postID: Int,comment: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return commentsDaoImp.addCommentToThePost(visitingUserID: postUserID, postID: postID, comment: comment, loggedUserID: loggedUserID)
    }
    
    func getAllComments(postUserID: Int,postID: Int) -> [CommentDetails] {
        
        var comments: [CommentDetails] = []
        
        for comment in commentsDaoImp.getAllCommmentsOfPost(postUserID: postUserID, postID: postID) {
            
            let username = userDaoImp.getUsername(userID: comment.commentUserID)
            
            comments.append(
                CommentDetails(
                    username: username,
                    comment: comment.comment,
                    commentUserID: comment.commentUserID)
            )
        }
        
        return comments
    }
}
