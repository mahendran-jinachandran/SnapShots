//
//  ProfileProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 06/12/22.
//

import UIKit

protocol ProfileControlsProtocols {
    func getProfileAccessibility(userID: Int) -> ProfileAccess
    func getUserDetails(userID: Int) -> User
    func getProfileDP() -> UIImage
    func getAllPosts(userID: Int) -> [(postImage: UIImage,postDetails: Post)]
    func sendFriendRequest(profileRequestedUser: Int) -> Bool
    func cancelFriendRequest(profileRequestedUser: Int) -> Bool
    func removeFrined(profileRequestedUser: Int) -> Bool
    func updateProfilePhoto(profilePhoto: UIImage)
}
