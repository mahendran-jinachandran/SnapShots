//
//  Post.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation

class Post {
    var postID: Int = 0
    var photo: String
    var caption: String
    var likes = Set<Int>()
    var postCreatedDate: String = ""
    var comments: [CommentDetails] = []
    var isLikesHidden: Bool = false
    var isCommentsHidden: Bool = false
    var isArchived: Bool = false
    
    
    init(postID: Int,photo: String, caption: String,postCreatedDate: String,isLikesHidden: Bool,isCommentsHidden: Bool,isArchived: Bool) {
        self.postID = postID
        self.photo = photo
        self.caption = caption
        self.postCreatedDate = postCreatedDate
        self.isLikesHidden = isLikesHidden
        self.isCommentsHidden = isCommentsHidden
        self.isArchived = isArchived
    }
}
