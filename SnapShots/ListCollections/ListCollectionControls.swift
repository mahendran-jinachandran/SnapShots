//
//  ListCollectionControlsa.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/01/23.
//

import Foundation

class ListCollectionControls: ListCollectionControlsProtocol {
 
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var savedPostDaoImp: SavedPostsDao = SavedPostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var commentsDaoImp: CommentDao = CommentDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp,userDaoImp: userDaoImp,savedPostDaoImp: savedPostDaoImp,likedUsersDaoImp: likesDaoImp,commentUsersDaoImp: commentsDaoImp)
    

    func getAllArchivedPosts() -> [ListCollectionDetails] {
        return postDaoImp.getAllArchivedPosts()
    }
    
    func getAllSavedCollections() -> [ListCollectionDetails] {
        return savedPostDaoImp.getAllSavedPosts()
    }
    
    func getPostDetails(userID: Int,postID: Int) -> Post {
        return postDaoImp.getPostDetails(userID: userID, postID: postID)
    }
    
    func isSavedPost(userID: Int,postID: Int) -> Bool {
        return savedPostDaoImp.isPostSaved(postUserID: userID, postID: postID)
    }
}
