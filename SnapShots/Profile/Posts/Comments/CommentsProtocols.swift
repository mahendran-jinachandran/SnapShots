//
//  CommentsProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol CommentsControlsProtocol {
    func addComment(postUserID: Int,postID: Int,comment: String) -> Bool
    func getAllComments(postUserID: Int,postID: Int) -> [CommentDetails]
    func deleteComment(userID: Int,postID: Int,commentID: Int) 
    func hasSpecialPermissions(postUserID: Int) -> Bool
    func getUsername(userID: Int) -> String 
}
