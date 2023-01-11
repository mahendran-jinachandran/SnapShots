//
//  SavedPostsDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/01/23.
//

import Foundation

protocol SavedPostsDao {
    func addPostToSaved(postUserID: Int,postID: Int) -> Bool
    func removePostFromSaved(postUserID: Int,postID: Int) -> Bool
    func getAllSavedPosts() -> [ListCollectionDetails]
    func isPostSaved(postUserID: Int,postID: Int) -> Bool
}
