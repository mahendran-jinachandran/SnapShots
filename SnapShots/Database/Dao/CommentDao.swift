//
//  CommentDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol CommentDao {
    func getAllCommmentsOfPost(postUserID: Int,postID: Int) -> [CommentDetails]
    func addCommentToThePost(visitingUserID: Int,postID: Int,comment: String,loggedUserID: Int) -> Bool
    func deleteCommentFromThePost(userID: Int,postID: Int,commentID: Int) -> Bool
    func getComment(rowID: Int) -> [Int:[String]] 
}
