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
    
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp,userDaoImp: userDaoImp,savedPostDaoImp: savedPostDaoImp)
    
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
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
    
                NotificationCenter.default.post(name: Constants.createPostEvent, object: nil,
                                                userInfo: [Constants.notificationCenterKeyName : postData])
                
            } else if operation == .update {
                // MARK: YET TO DO
                
                NotificationCenter.default.post(name: Constants.updatePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName : postData])
            }
        }
    }
}
