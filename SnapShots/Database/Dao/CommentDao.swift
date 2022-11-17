//
//  CommentDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol CommentDao {
    func getAllCommmentsOfPost(loggedUserID: Int) -> [(username: String,comment: String)]
    func addCommentToThePost(visitingUserID: Int,postID: Int,comment: String,loggedUserID: Int) -> Bool
}
