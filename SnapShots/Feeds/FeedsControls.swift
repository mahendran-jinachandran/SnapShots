//
//  FeedsControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import Foundation
import UIKit

class FeedsControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    
    func getAllPosts() -> [(userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)] {
        
        var feedPosts: [(userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)] = []
        
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let posts = postDaoImp.getAllFriendPosts(userID: userID)
        
        for (userID,username,postDetails) in posts {
            feedPosts.append((
                userID,
                username,
                UIImage().loadImageFromDiskWith(
                    fileName: Constants.noDPSavingFormat
                )!,
                postDetails,
                UIImage().loadImageFromDiskWith(
                    fileName: "\(userID)\(Constants.postSavingFormat)\(postDetails.postID)"
                )!
            ))
        }
        return feedPosts
    }
}
