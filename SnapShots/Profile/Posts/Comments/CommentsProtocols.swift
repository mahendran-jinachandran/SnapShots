//
//  CommentsProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol CommentsControlsProtocol {
    func addComment(postUserID: Int,postID: Int,comment: String) -> Bool
    func getAllComments(postUserID: Int,postID: Int) -> [CommentDetails]
}
