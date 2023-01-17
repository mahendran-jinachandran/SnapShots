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
        
        switch tableName {
            case .user:
                likeTableOperations(operation: operation, rowID: rowID)
            case .post:
                postTableOperations(operation: operation, rowID: rowID)
            case .likes:
                likeTableOperations(operation: operation, rowID: rowID)
            case .friendRequest:
                print("Not yet implemented")
            case .friends:
                friendsTableOperations(operation: operation, rowID: rowID)
            case .comments:
                commentsTableOperations(operation: operation, rowID: rowID)
            case .savedPosts:
                savedPostTableOperations(operation: operation, rowID: rowID)
            case .blockedUsers:
                blockedUsersTableOperations(operation: operation, rowID: rowID)
        }
    }
    
    private func likeTableOperations(operation: Operations,rowID: Int) {
        
        if operation == .insert {
            let postDetails = likesDaoImp.getPostID(rowID: rowID)
            NotificationCenter.default.post(name: Constants.likePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: postDetails])
        }
    }
    
    private func postTableOperations(operation: Operations,rowID: Int) {
        
        guard let postData = postDaoImp.getPostDetails(rowID: rowID) else {
            return
        }
        
        if operation == .insert {
            NotificationCenter.default.post(name: Constants.createPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName : postData])
            
        } else if operation == .update {
            NotificationCenter.default.post(name: Constants.updatePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName : postData])
        }
        
    }
    
    private func commentsTableOperations(operation: Operations,rowID: Int) {
        
        let commentData = commentsDaoImp.getComment(rowID: rowID)
        if operation == .insert {
            NotificationCenter.default.post(name: Constants.insertCommentPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: commentData])
        }
    }
    
    private func userTableOperations(operation: Operations,rowID: Int) {
        
        guard let userData = userDaoImp.getUserDetails(rowID: rowID) else {
            return
        }
        
        if operation == .update {
            NotificationCenter.default.post(name: Constants.updateUserEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: userData])
        }
    }
    
    private func friendsTableOperations(operation: Operations,rowID: Int) {
        
        let friendID = friendsDaoImp.getFriendID(rowID: rowID)
        if friendID == UserDefaults.standard.integer(forKey: Constants.loggedUserFormat) {
            return
        }
        
        let friendFeedPosts = postDaoImp.getFriendPostDetails(userID: friendID)
        if operation == .insert {
            NotificationCenter.default.post(name: Constants.addFriendPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: friendFeedPosts])
        }
    }
    
    private func savedPostTableOperations(operation: Operations,rowID: Int) {
        
        let savedPostDetails = savedPostDaoImp.getSavedPost(rowID: rowID)
        if operation == .insert {
            NotificationCenter.default.post(name: Constants.savingPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: savedPostDetails])
        }
    }
    
    private func blockedUsersTableOperations(operation: Operations,rowID: Int) {
        
        let blockedUserID = blockedUsersDaoImp.getBlockedUser(rowID: rowID)
        if operation == .insert {
            NotificationCenter.default.post(name: Constants.blockUserEvent, object: nil,userInfo: [
                Constants.notificationCenterKeyName: blockedUserID])
        }
    }
}
