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
    private let LIKED_TIME = "Liked_time"
    
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
        VALUES (\(visitingUserID),\(postID),\(loggedUserID),'\(AppUtility.getCurrentTime())');
        """
    
        let isLiked = sqliteDatabase.execute(query: insertIntoDB)
        print(isLiked)
        return isLiked
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
        SELECT \(LIKEDUSER_ID),\(LIKED_TIME)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        AND \(POST_ID) = \(postID);
        """
                
        var sortedlikedUsers: [(userID: Int,createdDate: String)] = []
        for (_,postLikedUserID) in sqliteDatabase.retrievingQuery(query: getLikesOfPostQuery) {
            sortedlikedUsers.append((
                Int(postLikedUserID[0])!,
                postLikedUserID[1]
            ))
        }
        
        sortedlikedUsers = sortedlikedUsers.sorted(by: {
            $0.createdDate.compare($1.createdDate) == .orderedAscending
        })
        
        var likedUsers: [User] = []
        for users in sortedlikedUsers {
            likedUsers.append(userDaoImp.getUserDetails(userID: users.userID)!)
        }
        
        return likedUsers
    }
}
