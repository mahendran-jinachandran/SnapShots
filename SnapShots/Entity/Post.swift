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
    var comments: [(Int, String, String)] = []
    var isArchived: Bool = false

    init(photo: String, caption: String) {
        self.photo = photo
        self.caption = caption
    }
    
    init(postID: Int,photo: String, caption: String,postCreatedDate: String,isArchived: Bool) {
        self.postID = postID
        self.photo = photo
        self.caption = caption
        self.postCreatedDate = postCreatedDate
        self.isArchived = isArchived
    }
}
