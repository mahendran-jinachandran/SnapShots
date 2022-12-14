//
//  ProfileControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 21/11/22.
//

import Foundation
import UIKit

class ProfileControls: ProfileControlsProtocols {


    

    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    private lazy var friendRequestDapImp: FriendRequestDao = FriendRequestDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    
    func getProfileAccessibility(userID: Int) -> ProfileAccess {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if loggedUser == userID {
            return .owner
        }
        
        var profileAccessibility = friendsDaoImp.isUserFriends(loggedUserID: loggedUser, visitingUserID: userID)
        
        if profileAccessibility {
            return .friend
        }
        
        profileAccessibility = friendRequestDapImp.isAlreadyRequestedFriend(loggedUserID: loggedUser, visitingUserID: userID)
        
        if profileAccessibility {
            return .requested
        } else {
            return .unknown
        }
    }
    
    func getUserDetails(userID: Int) -> User {
        return userDaoImp.getUserDetails(userID: userID)!
    }
    
    func getProfileDP(userID: Int) -> UIImage {
        return AppUtility.getDisplayPicture(userID: userID)
    }
    
    func getAllPosts(userID: Int) -> [Post] {
       var posts = postDaoImp.getAllPosts(userID: userID)
        
        posts = posts.sorted(by: {
            $0.postCreatedDate.compare($1.postCreatedDate) == .orderedAscending
        })
        
       return posts
    }
    
    func sendFriendRequest(profileRequestedUser: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendRequestDapImp.sendFriendRequest(loggedUserID: userID, visitingUserID: profileRequestedUser)
    }
    
    func cancelFriendRequest(profileRequestedUser: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendRequestDapImp.removeFriendRequest(removingUserID: profileRequestedUser, profileUserID: userID)
    }
    
    func removeFrined(profileRequestedUser: Int) -> Bool {
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return friendsDaoImp.removeFriend(loggedUserID: userID, removingUserID: profileRequestedUser)
    }
    
    func updateProfilePhoto(profilePhoto: UIImage) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let photoName = AppUtility.getProfilePhotoSavingFormat(userID: loggedUserID)
        profilePhoto.saveImage(imageName: photoName,image: profilePhoto)
        
        return userDaoImp.updatePhoto(photo: photoName, userID: loggedUserID)
    }
}
