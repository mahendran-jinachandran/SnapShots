//
//  NotificationProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol NotificationControlsProtocols {
    func getAllFriendRequests() -> [(userId: Int, userName: String,userDP: UIImage)]
    func acceptFriendRequest(acceptingUserID: Int) -> Bool
    func rejectFriendRequest(rejectingUserID: Int) -> Bool
}
