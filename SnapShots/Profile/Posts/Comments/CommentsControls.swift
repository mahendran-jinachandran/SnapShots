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
    
    func getAllComments(postUserID: Int,postID: Int) -> [(userDP: UIImage,username: String,comment:String)] {
        
        var comments: [(userDP: UIImage,username: String,comment:String)] = []
        
        for comment in commentsDaoImp.getAllCommmentsOfPost(postUserID: postUserID, postID: postID) {
            
            var userDP: UIImage!
            if UIImage().loadImageFromDiskWith(fileName: AppUtility.getProfilePhotoSavingFormat(userID: comment.commentUserID)) == nil {
                userDP = UIImage().loadImageFromDiskWith(fileName: Constants.noDPSavingFormat)
            } else {
                userDP = UIImage().loadImageFromDiskWith(fileName: AppUtility.getProfilePhotoSavingFormat(userID: comment.commentUserID))
            }
            
            let username = userDaoImp.getUsername(userID: comment.commentUserID)
            
            comments.append((
                userDP,
                username,
                comment.comment
            ))
        }
        
        return comments
    }
}
