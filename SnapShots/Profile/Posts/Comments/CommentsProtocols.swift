//
//  CommentsProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol CommentsControlsProtocol {
    func addComment(postUserID: Int,postID: Int,comment: String)
    func getAllComments(postUserID: Int,postID: Int) -> [(userDP: UIImage,username: String,comment:String,commentUserID: Int)]
}
