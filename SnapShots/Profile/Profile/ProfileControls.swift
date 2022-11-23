//
//  ProfileControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 21/11/22.
//

import Foundation
import UIKit

class ProfileControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    
    func getUsername(userID: Int) -> String {
        print(userDaoImp.getUsername(userID: userID))
        return userDaoImp.getUsername(userID: userID)
    }
    
    func getNumberOfFriends(userID: Int) -> String {
        return String(friendsDaoImp.getUserFriends(userID: userID).count)
    }
    
    func getNumberOfPosts(userID: Int) -> String {
        return String(postDaoImp.getAllPosts(userID: userID).count)
    }
    
    func getProfileBio(userID: Int) -> String {
        return userDaoImp.getBio(userID: userID)
    }
    
    func getAllPosts() -> [UIImage] {
        
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        var posts: [UIImage] = []
        let postDetails = postDaoImp.getAllPosts(userID: userID)
        
        for (postID,_) in postDetails {
            posts.append(
                UIImage().loadImageFromDiskWith(
                    fileName: "\(userID)APOSTA\(postID)"
                )!
            )
        }
        
        return posts
    }
}
