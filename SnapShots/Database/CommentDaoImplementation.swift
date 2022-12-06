//
//  CommentDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class CommentDaoImplementation: CommentDao {
    
    private let sqliteDatabase: DatabaseProtocol
    init(sqliteDatabase: DatabaseProtocol) {
        self.sqliteDatabase = sqliteDatabase
    }
    
    func getAllCommmentsOfPost(postUserID: Int,postID: Int) -> [(comment: String,commentUserID: Int)] {
        let getCommentsQuery = """
                SELECT
                    Comment,
                    CommentUser_id
                FROM
                    User
                    INNER JOIN Comments ON Comments.User_id = \(postUserID) AND
                    Comments.Post_id = \(postID) AND
                    Comments.CommentUser_id = User.User_id
        """
        
        var comments: [(comment: String,commentUserID: Int)] = []
        for (_,commentDetails) in sqliteDatabase.retrievingQuery(query: getCommentsQuery) {
            comments.append((commentDetails[0],Int(commentDetails[1])!))
        }
        
        return comments
    }
    
    func addCommentToThePost(visitingUserID: Int,postID: Int,comment: String,loggedUserID: Int) -> Bool {
        let insertCommentsQuery = """
        INSERT INTO Comments
        VALUES (\(visitingUserID),\(postID),'\(comment)',\(loggedUserID));
        """
        
        return sqliteDatabase.execute(query: insertCommentsQuery)
    }
}

