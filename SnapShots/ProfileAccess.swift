//
//  ProfileAccess.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import Foundation

enum ProfileAccess: Int {
    case owner = 1
    case friend
    case acquaintance
    
    var description: String {
        switch self {
        case .owner: return "Edit Profile"
        case .friend: return "Unfriend"
        case .acquaintance: return "Follow"
        }
    }
}
