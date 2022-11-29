//
//  Profile.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation

class Profile {
    var photo: String = ""
    var bio: String = ""
    var friendRequest = Set<Int>()
    var friendsList = Set<Int>()
    var posts: [Int: Post] = [:]
}
