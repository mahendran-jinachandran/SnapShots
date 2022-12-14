//
//  CommentDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class CommentDaoImplementation: CommentDao {
    
    private let USER_TABLE_NAME = "User"
    private let COMMENT_TABLE_NAME = "Comments"
    private let USER_ID = "User_id"
    private let POST_ID = "Post_id"
    private let COMMENT = "Comment"
    private let COMMENTUSER_ID = "CommentUser_id"
    
    
    private let sqliteDatabase: DatabaseProtocol
    init(sqliteDatabase: DatabaseProtocol) {
        self.sqliteDatabase = sqliteDatabase
    }
    
    func getAllCommmentsOfPost(postUserID: Int,postID: Int) -> [(comment: String,commentUserID: Int)] {
        let getCommentsQuery = """
                SELECT
                    \(COMMENT),
                    \(COMMENTUSER_ID)
                FROM
                    \(USER_TABLE_NAME)
                    INNER JOIN  \(COMMENT_TABLE_NAME) ON \(COMMENT_TABLE_NAME).\(USER_ID) = \(postUserID)
                    AND
                    \(COMMENT_TABLE_NAME).\(POST_ID) = \(postID)
                    AND
                    \(COMMENT_TABLE_NAME).\(COMMENTUSER_ID) =  \(USER_TABLE_NAME).\(USER_ID)
        """
        
        var comments: [(comment: String,commentUserID: Int)] = []
        for (_,commentDetails) in sqliteDatabase.retrievingQuery(query: getCommentsQuery) {
            comments.append((commentDetails[0],Int(commentDetails[1])!))
        }
        
        return comments
    }
    
    func addCommentToThePost(visitingUserID: Int,postID: Int,comment: String,loggedUserID: Int) -> Bool {
        let insertCommentsQuery = """
        INSERT INTO \(COMMENT_TABLE_NAME)
        VALUES (\(visitingUserID),\(postID),'\(comment)',\(loggedUserID));
        """
        
        return sqliteDatabase.execute(query: insertCommentsQuery)
    }
}

