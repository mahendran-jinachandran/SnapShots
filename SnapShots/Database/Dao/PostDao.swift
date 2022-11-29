//
//  PostDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

protocol PostDao{
    func uploadPost(postID: Int,photo: String,caption: String,userID: Int) -> Bool
    func createNewPostID(userID: Int) -> Int
    func getAllPosts(userID: Int) -> [(postID: Int, postDetails: Post)]
    func getAllFriendPosts(userID: Int) -> [(userId: Int,userName: String,post: Post)]
    func editCaptionInPost(caption: String,userID: Int,postID: Int) -> Bool
    func deletePost(userID: Int,postID: Int) -> Bool
}
