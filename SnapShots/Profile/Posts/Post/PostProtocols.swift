//
//  PostProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol PostControlsProtocol {
    func deletePost(postID: Int)
    func addLikeToThePost(postUserID: Int,postID: Int) -> Bool
    func removeLikeFromThePost(postUserID: Int,postID: Int) -> Bool
    func isAlreadyLikedThePost(postUserID: Int,postID: Int) -> Bool
    func getUsername(userID: Int) -> String
    func getPostImage(postImageName: String) -> UIImage
    func getUserDP(userID: Int) -> UIImage
    func isDeletionAllowed(userID: Int) -> Bool
}
