//
//  ListCollectionEntity.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/01/23.
//

import Foundation

enum ListCollectionEntity {
    case archive
    case savedCollection
    
    var description: String {
        switch self {
            case .archive: return "Archive"
            case .savedCollection: return "Saved Collection"
        }
    }
}
