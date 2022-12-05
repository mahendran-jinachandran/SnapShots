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
    private lazy var friendRequestDapImp: FriendRequestDao = FriendRequestDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    
    
    func getProfileAccessibility(userID: Int) -> ProfileAccess {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if loggedUser == userID {
            return .owner
        }
        
        let profileAccessibility = friendsDaoImp.isUserFriends(loggedUserID: loggedUser, visitingUserID: userID)
        
        if profileAccessibility {
            return .friend
        } else {
            return .acquaintance
        }
    }
    
    func getUserDetails(userID: Int) -> User {
        return userDaoImp.getUserDetails(userID: userID)!
    }
    
    func getProfileDP() -> UIImage {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)

        guard let postImage = UIImage().loadImageFromDiskWith(fileName: "\(Constants.dpSavingFormat)\(userID)") else {
            return UIImage().loadImageFromDiskWith(fileName: Constants.noDPSavingFormat)!
        }
        
        return postImage
    }
    
    func getAllPosts(userID: Int) -> [(postImage: UIImage,postDetails: Post)] {
        
        var posts: [(postImage: UIImage,postDetails: Post)] = []
        let postDetails = postDaoImp.getAllPosts(userID: userID)
        
        for (_,postDetails) in postDetails {
            guard let postImage =  UIImage().loadImageFromDiskWith(fileName: postDetails.photo) else {
                return posts
            }
            posts.append((postImage,postDetails))
        }
        return posts
    }
    
    func sendFriendRequest(requestingUser: Int) -> Bool {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendRequestDapImp.sendFriendRequest(loggedUserID: userID, visitingUserID: requestingUser)
    }
    
    func cancelFriendRequest(requestingUser: Int) -> Bool {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
      //  return friendRequestDapImp.cancelFriendRequest(loggedUserID: <#T##Int#>)
        return false
    }
}
