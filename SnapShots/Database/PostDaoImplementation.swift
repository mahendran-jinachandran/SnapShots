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
    private let IS_LIKES_HIDDEN = "IsLikesHidden"
    private let IS_COMMENTS_HIDDEN = "IsCommentsHidden"
    
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
            \(0),
            \(0)
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
        SELECT \(POST_ID),\(PHOTO),\(CAPTION),\(CREATED_TIME),\(IS_LIKES_HIDDEN),\(IS_COMMENTS_HIDDEN)
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
                     isLikesHidden: Int(post[4]) == 0 ? false : true ,
                     isCommentsHidden: Int(post[5]) == 0 ? false : true
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
                \(IS_LIKES_HIDDEN),
                \(IS_COMMENTS_HIDDEN)
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
                        postDetails: Post(
                            postID: Int(friend[2])!,
                            photo: friend[3],
                            caption: friend[4],
                            postCreatedDate: friend[5],
                            isLikesHidden: Int(friend[6]) == 0 ? false : true ,
                            isCommentsHidden: Int(friend[7]) == 0 ? false : true
                        )
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
    
    func hideLikesInPost(userID: Int,postID: Int) -> Bool {
        
        let hideLikesQuery = """
        UPDATE \(POST_TABLE_NAME)
        SET \(IS_LIKES_HIDDEN) = \(1)
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID)
        """
        
        return sqliteDatabase.execute(query: hideLikesQuery)
    }
    
    func unhideLikesInPost(userID: Int,postID: Int) -> Bool {
        
        let unhideLikesQuery = """
        UPDATE \(POST_TABLE_NAME)
        SET \(IS_LIKES_HIDDEN) = \(0)
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID)
        """
        
        return sqliteDatabase.execute(query: unhideLikesQuery)
    }
    
    func getLikesButtonVisibilityState(userID: Int, postID: Int) -> Bool {
        let getVisibilityStateQuery = """
        SELECT \(IS_LIKES_HIDDEN)
        FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(userID) AND
            \(POST_ID) = \(postID)
        """
        
        var isLikesHidden: Bool = false
        for (_,post) in sqliteDatabase.retrievingQuery(query: getVisibilityStateQuery) {
            isLikesHidden = Int(post[0]) == 0 ? false : true
        }
        
        return isLikesHidden
    }
    
    func hideCommentsInPost(userID: Int, postID: Int) -> Bool {
        let hideCommentsQuery = """
        UPDATE \(POST_TABLE_NAME)
        SET \(IS_COMMENTS_HIDDEN) = \(1)
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID)
        """
        
        return sqliteDatabase.execute(query: hideCommentsQuery)
    }
    
    func unhideCommentsInPost(userID: Int, postID: Int) -> Bool {
        let hideCommentsQuery = """
        UPDATE \(POST_TABLE_NAME)
        SET \(IS_COMMENTS_HIDDEN) = \(0)
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID)
        """
        
        return sqliteDatabase.execute(query: hideCommentsQuery)
    }
    
    func getCommentsButtonVisibilityState(userID: Int, postID: Int) -> Bool {
        
        let getVisibilityStateQuery = """
        SELECT \(IS_COMMENTS_HIDDEN)
        FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(userID) AND
            \(POST_ID) = \(postID)
        """
        
        var isCommentsHidden: Bool = false
        for (_,post) in sqliteDatabase.retrievingQuery(query: getVisibilityStateQuery) {
            isCommentsHidden = Int(post[0]) == 0 ? false : true
        }
        
        return isCommentsHidden
    }
}

