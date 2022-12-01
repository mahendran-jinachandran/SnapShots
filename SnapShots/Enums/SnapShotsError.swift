//
//  SnapShotsError.swift
//  SnapShots
//
//  Created by mahendran-14703 on 01/12/22.
//

import Foundation

enum PasswordActionError: Error {
    case empty
    case lessCharacters
    case mismatch
    
    var description: String {
        switch self {
            case .empty:
                return "Password cannot be empty"
            case .lessCharacters:
                return "Password should be minimum of length \(Constants.minimumPasswordLength) characters"
            case .mismatch:
                return "Password does not match"
        }
    }
}

enum UsernameError: Error {
    case cannotBeEmpty
    case alreadyTaken
    case invalidNumberOfCharacters
    
    var description: String {
        switch self {
            case .cannotBeEmpty:
                return "Username cannot be empty"
            case .alreadyTaken:
                return "Username is already taken"
            case .invalidNumberOfCharacters:
                return "Username should be \(Constants.userNameLength) characters"
        }
    }
}

enum PhoneNumberError: Error {
    case cannotBeEmpty
    case alreadyTaken
    case invalidFormat
    
    var description: String {
        switch self {
            case .cannotBeEmpty:
                return "Phone number cannot be empty"
            case .alreadyTaken:
                return "Phone number is already taken"
            case .invalidFormat:
                return "Phone number should be of length \(Constants.phoneNumberLength)"

        }
    }
}

