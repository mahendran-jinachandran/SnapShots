//
//  NotificationProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol NotificationControlsProtocols {
    func getAllFriendRequests() -> [User]
    func acceptFriendRequest(acceptingUserID: Int) -> Bool
    func rejectFriendRequest(rejectingUserID: Int) -> Bool
}
