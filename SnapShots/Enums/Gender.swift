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
    case preferNotSay
    
    var description: String {
        switch self {
        case .male: return Constants.MALE
        case .female: return Constants.FEMALE
        case .preferNotSay: return Constants.PREFER_NOT_SAY
        }
    }
}
