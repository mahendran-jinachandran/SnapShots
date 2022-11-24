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
    
    func getAllPosts() -> [(postImage: UIImage,postDetails: Post)] {
        
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        var posts: [(postImage: UIImage,postDetails: Post)] = []
        let postDetails = postDaoImp.getAllPosts(userID: userID)
        
        for (postID,postDetails) in postDetails {
            posts.append( (
                UIImage().loadImageFromDiskWith(
                    fileName: "\(userID)APOSTA\(postID)"
                )!,
                postDetails
            ) )
        }
        
        return posts
    }
}
