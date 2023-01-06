//
//  DBPublisher.swift
//  SnapShots
//
//  Created by mahendran-14703 on 04/01/23.
//

import Foundation



class DBPublisher {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func publish(operation: Operations,tableName: TableName,rowID: Int) {
        
        if tableName == .likes {
            if operation == .insert {
                likesDaoImp.getDetails(rowID: rowID)
            } else if operation == .delete {
                likesDaoImp.getDetails(rowID: rowID)
            }
        } else if tableName == .post {
            if operation == .insert {
                let data = postDaoImp.getPostDetails(rowID: rowID)
                NotificationCenter.default.post(name: Constants.insertPostEvent, object: nil,
                userInfo: data)
                
            } else if operation == .update {
                
            } else if operation == .delete {
                let data = postDaoImp.getPostDetails(rowID: rowID)
            }
        }
    }
}
