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
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    
        
    func getAllArchivedPosts() -> [ListCollectionDetails] {
        return postDaoImp.getAllArchivedPosts()
    }
}
