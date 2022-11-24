//
//  NewPostControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 22/11/22.
//

import Foundation
import UIKit

class NewPostControls {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    
    func addPost(caption: String,image: UIImage) {
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        let postID = postDaoImp.createNewPostID(userID: userID)
        
        image.saveImage(imageName: "\(userID)APOSTA\(postID)", image: image)
        
        postDaoImp.uploadPost(postID: postID, caption: caption, userID: userID)
        
    }
}
