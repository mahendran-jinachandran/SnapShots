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
    private let COMMENTED_TIME = "Commented_time"
    
    
    private let sqliteDatabase: DatabaseProtocol
    private var userDaoImp: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImp: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImp = userDaoImp
    }
    
    func getAllCommmentsOfPost(postUserID: Int,postID: Int) -> [CommentDetails] {
        let getCommentsQuery = """
                SELECT
                    \(COMMENT),
                    \(COMMENTUSER_ID),
                    \(COMMENTED_TIME)
                FROM
                    \(USER_TABLE_NAME)
                    INNER JOIN  \(COMMENT_TABLE_NAME) ON \(COMMENT_TABLE_NAME).\(USER_ID) = \(postUserID)
                    AND
                    \(COMMENT_TABLE_NAME).\(POST_ID) = \(postID)
                    AND
                    \(COMMENT_TABLE_NAME).\(COMMENTUSER_ID) =  \(USER_TABLE_NAME).\(USER_ID)
        """
    
        var commentsData: [(comment: String,commentedUserID: Int,commentedTime: String)] = []
        for (_,commentDetails) in sqliteDatabase.retrievingQuery(query: getCommentsQuery) {
            commentsData.append(
                (
                    commentDetails[0],
                    Int(commentDetails[1])!,
                    commentDetails[2]
                )
            )
        }
        
        commentsData = commentsData.sorted(by: {
            $0.commentedTime.compare($1.commentedTime) == .orderedAscending
        })
        
        var commentedUser: [CommentDetails] = []
        for user in commentsData {
            commentedUser.append(
                CommentDetails(
                    username: userDaoImp.getUsername(userID: user.commentedUserID),
                    comment: user.comment,
                    commentUserID: user.commentedUserID)
            )
        }
        
        return commentedUser
    }
    
    func addCommentToThePost(visitingUserID: Int,postID: Int,comment: String,loggedUserID: Int) -> Bool {
        let insertCommentsQuery = """
        INSERT INTO \(COMMENT_TABLE_NAME)
        VALUES (\(visitingUserID),\(postID),'\(comment)',\(loggedUserID),'\(AppUtility.getCurrentTime())');
        """
        
        return sqliteDatabase.execute(query: insertCommentsQuery)
    }
}

