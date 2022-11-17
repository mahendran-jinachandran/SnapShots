//
//  Gender.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation

enum Gender: Int,CustomStringConvertible {
    case male = 1
    case female
    
    var description: String {
        switch self {
        case .male: return "MALE"
        case .female: return "FEMALE"
        }
    }
}
