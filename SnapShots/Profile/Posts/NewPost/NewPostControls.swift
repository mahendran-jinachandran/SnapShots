//
//  NewPostControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 22/11/22.
//

import Foundation
import UIKit

class NewPostControls: NewPostControlProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    private lazy var friendsDaoImp: FriendsDao = FriendsDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, userDaoImplementation: userDaoImp)
    
    private lazy var postDaoImp: PostDao = PostDaoImplementation(sqliteDatabase: SQLiteDatabase.shared, friendsDaoImplementation: friendsDaoImp)
    
    func addPost(caption: String,image: UIImage) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let postID = postDaoImp.createNewPostID(userID: userID)
        
        let imageName = "\(userID)\(Constants.postSavingFormat)\(postID)"
        image.saveImage(imageName: imageName, image: image)
        
        print("C: \(caption.count)")
       return postDaoImp.uploadPost(postID: postID,photo: imageName,caption: caption, userID: userID)

    }
}
