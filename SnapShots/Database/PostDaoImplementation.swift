//
//  PostDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class PostDaoImplementation: PostDao {
    
    private let USER_TABLE_NAME = "User"
    private let POST_TABLE_NAME = "Post"
    private let POST_ID = "Post_id"
    private let PHOTO = "Photo"
    private let CAPTION = "Caption"
    private let USER_ID = "User_id"
    private let USERNAME = "Username"
    private let CREATED_TIME = "Created_time"
    private let IS_ARCHIVED = "isArchived"
    
    private let sqliteDatabase: DatabaseProtocol
    private let friendsDaoImplementation: FriendsDao
    init(sqliteDatabase: DatabaseProtocol,friendsDaoImplementation: FriendsDao) {
        self.sqliteDatabase = sqliteDatabase
        self.friendsDaoImplementation = friendsDaoImplementation
    }
    
    func uploadPost(postID: Int,photo: String,caption: String,userID: Int) -> Bool {
        let uploadPostQuery = """
        INSERT INTO \(POST_TABLE_NAME)
        VALUES (
            \(postID),
            '\(photo)',
            '\(caption)',
            \(userID),
            '\(AppUtility.getCurrentTime())',
            '0'
        )
        """
        
        return sqliteDatabase.execute(query: uploadPostQuery)
    }
    
    func createNewPostID(userID: Int) -> Int {
        let getExistingPostIDQuery = """
        SELECT \(POST_ID) FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        ORDER BY \(POST_ID)
        DESC LIMIT 1;
        """
        
        let existingPostIDs = sqliteDatabase.retrievingQuery(query: getExistingPostIDQuery)
        
        var newPostID = 0
        if existingPostIDs.isEmpty {
            newPostID = 1
        } else {
            for(_,post) in existingPostIDs {
                newPostID = Int(post[0])! + 1
            }
        }
        
        return newPostID
    }
    
    func getAllPosts(userID: Int) -> [Post] {
        let getAllPostQuery = """
        SELECT \(POST_ID),\(PHOTO),\(CAPTION),\(CREATED_TIME),\(IS_ARCHIVED)
        FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(userID);
        """
        
        var allPosts: [Post] = []
        for (_,post) in sqliteDatabase.retrievingQuery(query: getAllPostQuery) {
            allPosts.append(
                Post(postID: Int(post[0])!,
                     photo: post[1],
                     caption: post[2],
                     postCreatedDate: post[3],
                     isArchived: post[4] == "1" ? true : false
                    )
             )
        }
        
        return allPosts
    }
    
    func getAllFriendPosts(userID: Int) -> [FeedsDetails] {
        
        var myFriendIDs: [Int] = friendsDaoImplementation.getIDsOfFriends(userID: userID)
        myFriendIDs.append(userID)
    
        var feedPosts: [FeedsDetails] = []
        
        for friendID in myFriendIDs {
            
            let getAllFriendsPostQuery = """
            SELECT
                \(USER_TABLE_NAME).\(USER_ID),
                \(USERNAME),
                \(POST_ID),
                \(POST_TABLE_NAME).\(PHOTO),
                \(CAPTION),
                \(CREATED_TIME),
                \(IS_ARCHIVED)
            FROM
                \(USER_TABLE_NAME)
                INNER JOIN \(POST_TABLE_NAME) ON \(POST_TABLE_NAME).\(USER_ID) = \(friendID) AND
                \(USER_TABLE_NAME).\(USER_ID) = \(POST_TABLE_NAME).\(USER_ID);

            """

            for (_,friend) in sqliteDatabase.retrievingQuery(query: getAllFriendsPostQuery) {
                
                feedPosts.append(
                    FeedsDetails(
                        userID: Int(friend[0])!,
                        userName: friend[1],
                        postDetails: Post(postID: Int(friend[2])!, photo: friend[3], caption: friend[4],postCreatedDate: friend[5],isArchived: friend[6] == "1" ? true : false)
                    )
                )
            }
        }
        
        return feedPosts
    }
    
    func deletePost(userID: Int,postID: Int) -> Bool {
        let deletePostQuery = """
        DELETE FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        AND \(POST_ID) = \(postID);
        """
        
        return sqliteDatabase.execute(query: deletePostQuery)
    }
    
    func archiveThePost(userID: Int,postID: Int) -> Bool {
        let archivePostQuery = """
        UPDATE \(POST_TABLE_NAME)
        SET \(IS_ARCHIVED) = 1
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID)
        """
        return sqliteDatabase.execute(query: archivePostQuery)
        
    }
}

