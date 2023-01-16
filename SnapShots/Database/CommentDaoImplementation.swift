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
    private let COMMENT_ID = "CommentID"
    
    
    private let sqliteDatabase: DatabaseProtocol
    private var userDaoImp: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImp: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImp = userDaoImp
    }
    
    func getAllCommmentsOfPost(postUserID: Int,postID: Int) -> [CommentDetails] {
        let getCommentsQuery = """
                SELECT
                    \(COMMENT_ID),
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
    
        var commentsData: [(commentID: Int,comment: String,commentedUserID: Int,commentedTime: String)] = []
        for (_,commentDetails) in sqliteDatabase.retrievingQuery(query: getCommentsQuery) {
            
            commentsData.append(
                (
                    Int(commentDetails[0])!,
                    commentDetails[1],
                    Int(commentDetails[2])!,
                    commentDetails[3]
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
                    commentID: user.commentID,
                    username: userDaoImp.getUsername(userID: user.commentedUserID),
                    comment: user.comment,
                    commentUserID: user.commentedUserID)
            )
        }
        
        return commentedUser
    }
    
    func addCommentToThePost(visitingUserID: Int,postID: Int,comment: String,loggedUserID: Int) -> Bool {
        
        
        let commentID = createNewCommentID(userID: visitingUserID,postID: postID)
        
        let insertCommentsQuery = """
        INSERT INTO \(COMMENT_TABLE_NAME)
        VALUES (\(commentID),\(visitingUserID),\(postID),'\(comment)',\(loggedUserID),'\(AppUtility.getCurrentTime())');
        """
        
        return sqliteDatabase.execute(query: insertCommentsQuery)
    }
    
    func createNewCommentID(userID: Int,postID: Int) -> Int {
        let getExistingCommentIDQuery = """
        SELECT \(COMMENT_ID) FROM \(COMMENT_TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        AND \(POST_ID) = \(postID)
        ORDER BY \(COMMENT_ID)
        DESC LIMIT 1;
        """
        
        let existingCommentIDs = sqliteDatabase.retrievingQuery(query: getExistingCommentIDQuery)
        
        var newCommentID = 0
        if existingCommentIDs.isEmpty {
            newCommentID = 1
        } else {
            for(_,comment) in existingCommentIDs {
                newCommentID = Int(comment[0])! + 1
            }
        }
        
        return newCommentID
    }
    
    func deleteCommentFromThePost(userID: Int,postID: Int,commentID: Int) -> Bool {
        
        let deleteCommentsQuery = """
        DELETE FROM \(COMMENT_TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        AND \(POST_ID) = \(postID)
        AND \(COMMENT_ID) = \(commentID)
        """
        
        return sqliteDatabase.execute(query: deleteCommentsQuery)
    }
    
    func getComment(rowID: Int) -> [Int:[String]] {
        
        let getCommentQuery = """
        SELECT * FROM \(COMMENT_TABLE_NAME)
        WHERE rowid = \(rowID)
        """
        
        return sqliteDatabase.retrievingQuery(query: getCommentQuery)
    }
}

