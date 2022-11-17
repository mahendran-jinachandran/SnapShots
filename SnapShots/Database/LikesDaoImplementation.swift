//
//  LikesDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class LikesDaoImplementation: LikesDao {
    
    private let sqliteDatabase: DatabaseProtocol
    private var userDaoImp: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImp: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImp = userDaoImp
    }
    
    func isPostAlreadyLiked(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool {
        let getLikesOfPostQuery = """
        SELECT LikedUser_id FROM Likes
        WHERE User_id = \(visitingUserID) AND Post_id = \(postID)
        AND LikedUser_id = \(loggedUserID);
        """
        
        return !sqliteDatabase.retrievingQuery(query: getLikesOfPostQuery).isEmpty
    }
    
    func addLikeToThePost(loggedUserID: Int,visitingUserID: Int,postID: Int) -> Bool {
        let insertIntoDB = """
        INSERT INTO Likes
        VALUES (\(visitingUserID),\(postID),\(loggedUserID));
        """
    
        return sqliteDatabase.execute(query: insertIntoDB)
    }
    
    func getAllLikesOfPost(userID: Int,postID: Int) -> [String] {
        let getLikesOfPostQuery = """
        SELECT LikedUser_id FROM Likes
        WHERE User_id = \(userID) AND Post_id = \(postID);
        """
        
        var likedUsers: [String] = []
        for (_,postLikedUserID) in sqliteDatabase.retrievingQuery(query: getLikesOfPostQuery){
            likedUsers.append(userDaoImp.getUsername(userID: Int(postLikedUserID[0])!))
        }
        
        return likedUsers
    }
}
