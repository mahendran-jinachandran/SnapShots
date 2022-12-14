//
//  PostDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

protocol PostDao{
    func uploadPost(postID: Int,photo: String,caption: String,userID: Int) -> Bool
    func createNewPostID(userID: Int) -> Int
    func getAllPosts(userID: Int) ->[Post]
    func getAllFriendPosts(userID: Int) -> [FeedsDetails]
    func deletePost(userID: Int,postID: Int) -> Bool
}
