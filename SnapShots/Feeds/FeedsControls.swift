//
//  FeedsControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class FeedsControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    private lazy var likesDaoImp: LikesDao = LikesDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImp: userDaoImp)
    
    func getAllPosts() -> [(userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)] {
        
        var feedPosts: [(userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)] = []
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let posts = postDaoImp.getAllFriendPosts(userID: loggedUser)
        
        for (userID,username,postDetails) in posts {
            let userDP = AppUtility.getDisplayPicture(userID: userID)
            
            feedPosts.append((
                userID,
                username,
                userDP,
                postDetails,
                UIImage().loadImageFromDiskWith(
                    fileName: "\(userID)\(Constants.postSavingFormat)\(postDetails.postID)"
                )!
            ))
        }
        
        return feedPosts
    }
    
    func isAlreadyLikedThePost(postDetails: (userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)) -> Bool {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return likesDaoImp.isPostAlreadyLiked(loggedUserID: loggedUser, visitingUserID: postDetails.userID, postID: postDetails.postDetails.postID)
    }
    
    func addLikeToThePost(postUserID: Int,postID: Int) -> Bool {
        
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return likesDaoImp.addLikeToThePost(loggedUserID: loggedUser, visitingUserID: postUserID, postID: postID)
    }
    
    func removeLikeFromThePost(postUserID: Int,postID: Int) -> Bool {
        let loggedUser = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        return likesDaoImp.removeLikeFromThePost(loggedUserID: loggedUser, visitingUserID: postUserID, postID: postID)
    }
}
