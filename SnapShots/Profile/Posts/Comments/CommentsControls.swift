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
    
    func addComment(postUserID: Int,postID: Int,comment: String) {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        if commentsDaoImp.addCommentToThePost(visitingUserID: postUserID, postID: postID, comment: comment, loggedUserID: loggedUserID) {
            // MARK: SHOW TOAST COMMENTED
        } else {
            // MARK: SHOW TOAST COMMENTED FAILED
        }
    }
    
    func getAllComments(postUserID: Int,postID: Int) -> [(userDP: UIImage,username: String,comment:String,commentUserID: Int)] {
        
        var comments: [(userDP: UIImage,username: String,comment:String,commentUserID: Int)] = []
        
        for comment in commentsDaoImp.getAllCommmentsOfPost(postUserID: postUserID, postID: postID) {
            
            let userDP = AppUtility.getDisplayPicture(userID: comment.commentUserID)
            let username = userDaoImp.getUsername(userID: comment.commentUserID)
            
            comments.append((
                userDP,
                username,
                comment.comment,
                comment.commentUserID
            ))
        }
        
        return comments
    }
}
