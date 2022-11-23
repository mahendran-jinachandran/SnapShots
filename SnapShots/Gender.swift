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
    case ratherNotSay
    
    var description: String {
        switch self {
        case .male: return "MALE"
        case .female: return "FEMALE"
        case .ratherNotSay: return "RATHER NOT SAY"
        }
    }
}
