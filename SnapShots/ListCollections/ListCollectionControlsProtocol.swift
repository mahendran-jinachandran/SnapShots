//
//  ListCollectionProtocol.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/01/23.
//

import Foundation

protocol ListCollectionControlsProtocol {
    func getAllArchivedPosts() -> [ListCollectionDetails]
    func getAllSavedCollections() -> [ListCollectionDetails]
    func getPostDetails(userID: Int,postID: Int) -> Post
    func isSavedPost(userID: Int,postID: Int) -> Bool
}
