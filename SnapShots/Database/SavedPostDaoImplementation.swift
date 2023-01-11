//
//  SavedPostDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/01/23.
//

import Foundation

class SavedPostDaoImplementation: SavedPostsDao {
    
    private let SAVED_POSTS_TABLE_NAME = "SavedPosts"
    private let USER_ID = "User_id"
    private let POST_USER_ID = "PostUser_id"
    private let POST_ID = "Post_id"
    
    private let sqliteDatabase: DatabaseProtocol
    private let userDaoImp: UserDao
    init(sqliteDatabase: DatabaseProtocol,userDaoImp: UserDao) {
        self.sqliteDatabase = sqliteDatabase
        self.userDaoImp = userDaoImp
    }
    
    func addPostToSaved(postUserID: Int, postID: Int) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        let insertIntoSavedQuery = """
        INSERT INTO \(SAVED_POSTS_TABLE_NAME)
        VALUES (\(loggedUserID),\(postUserID),\(postID));
        """
        
        return sqliteDatabase.execute(query: insertIntoSavedQuery)
    }
    
    func removePostFromSaved(postUserID: Int, postID: Int) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        let removeFromSavedQuery = """
        DELETE FROM \(SAVED_POSTS_TABLE_NAME)
        WHERE \(USER_ID) = \(loggedUserID) AND
        \(POST_USER_ID) = \(postUserID) AND
        \(POST_ID) = \(postID)
        """
        
        return sqliteDatabase.execute(query: removeFromSavedQuery)
    }
    
    func getAllSavedPosts() -> [ListCollectionDetails] {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        let getAllSavedPosts = """
        SELECT \(POST_USER_ID),\(POST_ID) FROM
        \(SAVED_POSTS_TABLE_NAME)
        WHERE \(USER_ID) = \(loggedUserID)
        """
        
        var posts = [ListCollectionDetails]()
        
        for (_,post) in sqliteDatabase.retrievingQuery(query: getAllSavedPosts) {
            posts.append(
                ListCollectionDetails(
                    userID: Int(post[0])!,
                    postID: Int(post[1])!
                )
            )
        }
        
        return posts
    }
    
    func isPostSaved(postUserID: Int,postID: Int) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        let getAllSavedPosts = """
          SELECT * FROM \(SAVED_POSTS_TABLE_NAME)
          WHERE \(USER_ID) = \(loggedUserID) AND
          \(POST_USER_ID) = \(postUserID) AND
          \(POST_ID) = \(postID)
        """
        
        let isSaved = sqliteDatabase.booleanQuery(query: getAllSavedPosts)
        return isSaved
    }
}
