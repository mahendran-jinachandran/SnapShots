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
    private let SAVED_POSTS_TABLE_NAME = "SavedPosts"
    private let POST_ID = "Post_id"
    private let PHOTO = "Photo"
    private let CAPTION = "Caption"
    private let USER_ID = "User_id"
    private let USERNAME = "Username"
    private let CREATED_TIME = "Created_time"
    private let IS_LIKES_HIDDEN = "IsLikesHidden"
    private let IS_COMMENTS_HIDDEN = "IsCommentsHidden"
    private let BLOCKED_USERS_TABLE_NAME = "BlockedUsers"
    private let BLOCKED_USER_ID = "BlockedUser_id"
    private let IS_ARCHIVED = "isArchived"
    private let POST_USER_ID = "PostUser_id"
    
    
    private let sqliteDatabase: DatabaseProtocol
    private let friendsDaoImplementation: FriendsDao
    private let userDaoImp: UserDao
    private let savedPostsDaoImp: SavedPostsDao
    private let likedUsersDaoImp: LikesDao
    private let commentUsersDaoImp: CommentDao
    
    init(sqliteDatabase: DatabaseProtocol,friendsDaoImplementation: FriendsDao,userDaoImp: UserDao,savedPostDaoImp: SavedPostsDao,likedUsersDaoImp: LikesDao,commentUsersDaoImp: CommentDao) {
        self.sqliteDatabase = sqliteDatabase
        self.friendsDaoImplementation = friendsDaoImplementation
        self.userDaoImp = userDaoImp
        self.savedPostsDaoImp = savedPostDaoImp
        self.likedUsersDaoImp = likedUsersDaoImp
        self.commentUsersDaoImp = commentUsersDaoImp
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
        SELECT \(POST_ID),\(PHOTO),\(CAPTION),\(CREATED_TIME),\(IS_LIKES_HIDDEN),\(IS_COMMENTS_HIDDEN),\(IS_ARCHIVED)
        FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(userID) AND
        \(IS_ARCHIVED) = \(0);
        """
        
        var allPosts: [Post] = []
        for (_,post) in sqliteDatabase.retrievingQuery(query: getAllPostQuery) {
            
            let postDetails = Post(postID: Int(post[0])!,
                               photo: post[1],
                               caption: post[2],
                               postCreatedDate: post[3],
                               isLikesHidden: Int(post[4]) == 0 ? false : true ,
                               isCommentsHidden: Int(post[5]) == 0 ? false : true,
                               isArchived: Int(post[6]) == 0 ? false : true
                              )
            
            for likedUser in likedUsersDaoImp.getAllLikesOfPost(userID: userID, postID: Int(post[0])!) {
                postDetails.likes.insert(likedUser.userID)
            }
            
            for commentedUser in commentUsersDaoImp.getAllCommmentsOfPost(postUserID: userID, postID: Int(post[0])!) {
                postDetails.comments.append(commentedUser)
            }
        
            
            allPosts.append(postDetails)
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
                \(IS_COMMENTS_HIDDEN),
                \(IS_ARCHIVED)
            FROM
                \(USER_TABLE_NAME)
                INNER JOIN \(POST_TABLE_NAME) ON \(POST_TABLE_NAME).\(USER_ID) = \(friendID) AND
                \(USER_TABLE_NAME).\(USER_ID) = \(POST_TABLE_NAME).\(USER_ID)
            WHERE \(IS_ARCHIVED) = \(0) AND \(USER_TABLE_NAME).\(USER_ID) NOT IN
            (SELECT \(BLOCKED_USER_ID) FROM \(BLOCKED_USERS_TABLE_NAME) WHERE \(USER_ID) = \(userID))
            ;
            """
            
            let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
            
            for (_,friend) in sqliteDatabase.retrievingQuery(query: getAllFriendsPostQuery) {
                
                let isSavedQuery = """
                SELECT * FROM \(SAVED_POSTS_TABLE_NAME)
                WHERE \(USER_ID) = \(loggedUserID) AND
                \(POST_USER_ID) = \(Int(friend[0])!) AND
                \(POST_ID) = \(Int(friend[2])!)
                """
                
                let isSaved = sqliteDatabase.retrievingQuery(query: isSavedQuery).isEmpty ? false : true
                
                let post = Post(
                    postID: Int(friend[2])!,
                    photo: friend[3],
                    caption: friend[4],
                    postCreatedDate: friend[5],
                    isLikesHidden: Int(friend[6]) == 0 ? false : true ,
                    isCommentsHidden: Int(friend[7]) == 0 ? false : true,
                    isArchived: Int(friend[8]) == 0 ? false : true
                )
                
                for likedUser in likedUsersDaoImp.getAllLikesOfPost(userID: friendID, postID: Int(friend[2])!) {
                    post.likes.insert(likedUser.userID)
                }
                
                for commentedUser in commentUsersDaoImp.getAllCommmentsOfPost(postUserID: userID, postID: Int(friend[2])!) {
                    post.comments.append(commentedUser)
                }
                
                
                
                
                feedPosts.append(
                    FeedsDetails(
                        userID: Int(friend[0])!,
                        userName: friend[1],
                        postDetails: post,
                        isSaved: isSaved
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
    
    func archiveThePost(userID: Int,postID: Int) -> Bool {
        let archivePostQuery = """
        UPDATE \(POST_TABLE_NAME)
        SET \(IS_ARCHIVED) = \(1)
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID)
        """
        
        return sqliteDatabase.execute(query: archivePostQuery)
    }
    
    func unarchiveThePost(userID: Int,postID: Int) -> Bool {
        let unarchivePostQuery = """
        UPDATE \(POST_TABLE_NAME)
        SET \(IS_ARCHIVED) = \(0)
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID)
        """
        
        return sqliteDatabase.execute(query: unarchivePostQuery)
    }
    
    func getAllArchivedPosts() -> [ListCollectionDetails] {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        let getArchivedPostsQuery = """
        SELECT \(USER_ID),\(POST_ID) FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(loggedUserID) AND
        \(IS_ARCHIVED) = \(1)
        """
        
        var posts = [ListCollectionDetails]()
        for (_,post) in sqliteDatabase.retrievingQuery(query: getArchivedPostsQuery) {
            posts.append(
                ListCollectionDetails(
                    userID: Int(post[0])!,
                    postID: Int(post[1])!
                )
            )
        }
        
        return posts
    }
    
    func getPostDetails(userID: Int,postID: Int) -> Post {
        
        let getPostQuery = """
        SELECT \(POST_ID),\(PHOTO),\(CAPTION),\(CREATED_TIME),\(IS_LIKES_HIDDEN),\(IS_COMMENTS_HIDDEN),\(IS_ARCHIVED)
        FROM \(POST_TABLE_NAME)
        WHERE \(USER_ID) = \(userID) AND
        \(POST_ID) = \(postID);
        """
        
        var postDetail: Post!
        for (_,post) in sqliteDatabase.retrievingQuery(query: getPostQuery) {
            postDetail = Post(
                postID: Int(post[0])!,
                photo: post[1],
                caption: post[2],
                postCreatedDate: post[3],
                isLikesHidden: Int(post[4]) == 0 ? false : true ,
                isCommentsHidden: Int(post[5]) == 0 ? false : true,
                isArchived: Int(post[6]) == 0 ? false : true
            )
            
            for likedUser in likedUsersDaoImp.getAllLikesOfPost(userID: userID, postID: Int(post[0])!) {
                postDetail.likes.insert(likedUser.userID)
            }
            
            for commentedUser in commentUsersDaoImp.getAllCommmentsOfPost(postUserID: userID, postID: Int(post[0])!) {
                postDetail.comments.append(commentedUser)
            }
        }
        
        return postDetail
    }
    
    func getPostDetails(rowID: Int) -> FeedsDetails? {
        
        let getRowQuery = """
        SELECT * FROM \(POST_TABLE_NAME)
        WHERE rowid = \(rowID);
        """
        
        var feedsDetails: FeedsDetails?
        if let data = sqliteDatabase.retrievingQuery(query: getRowQuery)[1] {
           let post = Post(
                postID: Int(data[0])!,
                photo: data[1],
                caption:  data[2],
                postCreatedDate: data[4],
                isLikesHidden: data[5] == "0" ? false : true,
                isCommentsHidden: data[6] == "0" ? false : true,
                isArchived: data[7] == "0" ? false : true
            )
            
            for likedUser in likedUsersDaoImp.getAllLikesOfPost(userID: Int(data[3])!, postID: Int(data[0])!) {
                post.likes.insert(likedUser.userID)
            }
            
            for commentedUser in commentUsersDaoImp.getAllCommmentsOfPost(postUserID: Int(data[3])!, postID: Int(data[0])!) {
                post.comments.append(commentedUser)
            }
            
            feedsDetails = FeedsDetails(
                userID: Int(data[3])!,
                userName: userDaoImp.getUsername(userID: Int(data[3])!),
                postDetails: post,
                isSaved: savedPostsDaoImp.isPostSaved(
                    postUserID: Int(data[3])!,
                    postID: Int(data[0])!)
            )
        }
        
        return feedsDetails
    }
    
    func getFriendPostDetails(userID: Int) -> [FeedsDetails] {
        
        let username = userDaoImp.getUsername(userID: userID)
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        var feedsDetails = [FeedsDetails]()
        
        for post in getAllPosts(userID: userID) {
            
            
            let isSavedQuery = """
            SELECT * FROM \(SAVED_POSTS_TABLE_NAME)
            WHERE \(USER_ID) = \(loggedUserID) AND
            \(POST_USER_ID) = \(userID) AND
            \(POST_ID) = \(post.postID)
            """
            
            let isSaved = sqliteDatabase.retrievingQuery(query: isSavedQuery).isEmpty ? false : true
            
            
            feedsDetails.append(
                FeedsDetails(
                    userID: userID,
                    userName: username,
                    postDetails: post,
                    isSaved: isSaved)
            )
        }
        
        return feedsDetails
    }
}

