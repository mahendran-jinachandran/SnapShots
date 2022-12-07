//
//  LikesProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol LikesControlsProtocol {
    func getAllLikedUsers(postUserID: Int,postID: Int) -> [(user: User,profilePhoto: UIImage)]
}
