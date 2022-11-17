//
//  Post.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation

class Post {
    var postID: Int = 0
    var photo: Bool
    var caption: String
    var likes = Set<Int>()
    var comments: [(Int, String, String)] = []

    init(photo: Bool, caption: String) {
        self.photo = photo
        self.caption = caption
    }
    
    init(postID: Int,photo: Bool, caption: String) {
        self.postID = postID
        self.photo = photo
        self.caption = caption
    }
}
