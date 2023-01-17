//
//  DBPublisher.swift
//  SnapShots
//
//  Created by mahendran-14703 on 12/01/23.
//

import Foundation

class DBPublisher {

    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var savedPostDaoImp: SavedPostsDao = SavedPostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp,userDaoImp: userDaoImp,savedPostDaoImp: savedPostDaoImp,likedUsersDaoImp: likesDaoImp,commentUsersDaoImp: commentsDaoImp)
    private lazy var blockedUsersDaoImp: BlockedUserDao = BlockedUserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    

    func publish(operation: Operations,tableName: TableName,rowID: Int) {
        
        if tableName == .likes {
            if operation == .insert {
                
                let postDetails = likesDaoImp.getPostID(rowID: rowID)
                NotificationCenter.default.post(name: Constants.likePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: postDetails])
                
            }
            
        } else if tableName == .post {
            
            guard let postData = postDaoImp.getPostDetails(rowID: rowID) else {
                return
            }
            
            if operation == .insert {
                NotificationCenter.default.post(name: Constants.createPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName : postData])
                
            } else if operation == .update {
                NotificationCenter.default.post(name: Constants.updatePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName : postData])
            }
            
        } else if tableName == .comments{
          
            let commentData = commentsDaoImp.getComment(rowID: rowID)
            if operation == .insert {
                NotificationCenter.default.post(name: Constants.insertCommentPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: commentData])
            }
        } else if tableName == .user {
            
            guard let userData = userDaoImp.getUserDetails(rowID: rowID) else {
                return
            }
            
            if operation == .update {
                NotificationCenter.default.post(name: Constants.updateUserEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: userData])
            }
            
        } else if tableName == .friends {
            
            let friendID = friendsDaoImp.getFriendID(rowID: rowID)
            if friendID == UserDefaults.standard.integer(forKey: Constants.loggedUserFormat) {
                return
            }
            
            let friendFeedPosts = postDaoImp.getFriendPostDetails(userID: friendID)
            if operation == .insert {
                NotificationCenter.default.post(name: Constants.addFriendPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: friendFeedPosts])
            }
        } else if tableName == .blockedUsers {
            
            let blockedUserID = blockedUsersDaoImp.getBlockedUser(rowID: rowID)
            if operation == .insert {
                NotificationCenter.default.post(name: Constants.blockUserEvent, object: nil,userInfo: [
                    Constants.notificationCenterKeyName: blockedUserID])
            }
            
        } else {
            print("Not yet implemented")
        }
    }
}
