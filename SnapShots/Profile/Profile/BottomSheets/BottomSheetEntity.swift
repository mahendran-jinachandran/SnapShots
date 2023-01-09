//
//  BottomSheetEntity.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/01/23.
//

import Foundation

enum BottomSheetEntity {
    case settings
    case archives
    case blockedUsers
    case saved
    
    var description: String {
        switch self {
        case .settings: return "Settings"
        case .archives: return "Archive"
        case .blockedUsers: return "Blocked Users"
        case .saved: return "Saved Collections"
        }
    }
}
