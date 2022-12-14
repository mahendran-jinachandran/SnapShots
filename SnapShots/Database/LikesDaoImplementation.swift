//
//  LikesDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class LikesDaoImplementation: LikesDao {
    
    private let TABLE_NAME = "Likes"
    private let USER_ID = "User_id"
    private let POST_ID = "Post_id"
    private let LIKEDUSER_ID = "LikedUser_id"
    
    
    private let sqliteDatabase: DatabaseProtocol
    private var userDaoImp: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImp: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImp = userDaoImp
    }
    
    func isPostAlreadyLiked(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool {
        let getLikesOfPostQuery = """
        SELECT \(LIKEDUSER_ID)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(visitingUserID)
        AND \(POST_ID) = \(postID)
        AND \(LIKEDUSER_ID) = \(loggedUserID);
        """
        
        return !sqliteDatabase.retrievingQuery(query: getLikesOfPostQuery).isEmpty
    }
    
    func addLikeToThePost(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool {
        
        let insertIntoDB = """
        INSERT INTO \(TABLE_NAME)
        VALUES (\(visitingUserID),\(postID),\(loggedUserID));
        """
    
        return sqliteDatabase.execute(query: insertIntoDB)
    }
    
    func removeLikeFromThePost(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool {
        let removeFromDB = """
        DELETE FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(visitingUserID)
        AND \(POST_ID) = \(postID)
        AND \(LIKEDUSER_ID) = \(loggedUserID)
        """
        
        return sqliteDatabase.execute(query: removeFromDB)
    }
    
    func getAllLikesOfPost(userID: Int,postID: Int) -> [User] {
        let getLikesOfPostQuery = """
        SELECT \(LIKEDUSER_ID)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        AND \(POST_ID) = \(postID);
        """
        
        var likedUsers: [User] = []
        for (_,postLikedUserID) in sqliteDatabase.retrievingQuery(query: getLikesOfPostQuery){            
            likedUsers.append(userDaoImp.getUserDetails(userID: Int(postLikedUserID[0])!)!)
        }
        
        return likedUsers
    }
}
