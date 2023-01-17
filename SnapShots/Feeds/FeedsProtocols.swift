//
//  FeedsProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol FeedsControlsProtocol {
    func getAllPosts() -> [FeedsDetails]
    func isAlreadyLikedThePost(postDetails: (userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)) -> Bool
    func addLikeToThePost(postUserID: Int,postID: Int) -> Bool
    func removeLikeFromThePost(postUserID: Int,postID: Int) -> Bool
    func isDeletionAllowed(userID: Int) -> Bool
    func deletePost(postID: Int) -> Bool
    func getAllLikedUsers(postUserID: Int,postID: Int) -> Int
    func getAllComments(postUserID: Int,postID: Int) -> Int
    func removeFriend(profileRequestedUser: Int) -> Bool
    func addPostToSaved(postUserID: Int,postID: Int) -> Bool
    func removePostFromSaved(postUserID: Int,postID: Int) -> Bool
    func getUsername(userID: Int) -> String
    func getAllUserPosts(userID: Int) -> [FeedsDetails]
    func isUserFriends(userID: Int,loggedUserID: Int) -> Bool
}
