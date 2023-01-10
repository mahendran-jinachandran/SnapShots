//
//  PostProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol PostControlsProtocol {
    func deletePost(postID: Int) -> Bool
    func addLikeToThePost(postUserID: Int,postID: Int) -> Bool
    func removeLikeFromThePost(postUserID: Int,postID: Int) -> Bool
    func isAlreadyLikedThePost(postUserID: Int,postID: Int) -> Bool
    func getUsername(userID: Int) -> String
    func getPostImage(postImageName: String) -> UIImage
    func getUserDP(userID: Int) -> UIImage
    func isDeletionAllowed(userID: Int) -> Bool
    func getAllLikedUsers(postUserID: Int,postID: Int) -> Int
    func getAllComments(postUserID: Int,postID: Int) -> Int
    func getAllComments(postUserID: Int,postID: Int) -> [CommentDetails]
    func addComment(postUserID: Int,postID: Int,comment: String) -> Bool
    func removeFriend(profileRequestedUser: Int) -> Bool
    func hideLikesCount(userID: Int,postID: Int)
    func unhideLikesCount(userID: Int,postID: Int)
    func getLikesButtonVisibilityState(userID: Int,postID: Int) -> Bool
    func hideComments(userID: Int,postID: Int)
    func unhideComments(userID: Int,postID: Int)
    func getCommentsButtonVisibilityState(userID: Int,postID: Int) -> Bool
    func hasSpecialPermissions(postUserID: Int) -> Bool
    func deleteComment(userID: Int,postID: Int,commentID: Int)
    func archiveThePost(userID: Int,postID: Int) -> Bool
    func unarchiveThePost(userID: Int,postID: Int) -> Bool
}
