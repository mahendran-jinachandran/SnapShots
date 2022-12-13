//
//  FriendsProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/12/22.
//

import Foundation

protocol FriendsControlsProtocol {
    func getAllFriends(userID: Int) -> [User]
}
