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
    
    func getAllCommmentsOfPost(loggedUserID: Int) -> [(username: String,comment: String)] {
        let getCommentsQuery = """
                SELECT
                    Username,
                    Comment
                FROM
                    User
                    INNER JOIN Comments ON Comments.User_id = \(loggedUserID) AND
                    Comments.CommentUser_id = User.User_id
        """
        
        var comments: [(username: String,comment: String)] = []
        for (_,commentDetails) in sqliteDatabase.retrievingQuery(query: getCommentsQuery) {
            comments.append((commentDetails[0],commentDetails[1]))
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

