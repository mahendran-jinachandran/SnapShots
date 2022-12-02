//
//  Constants.swift
//  SnapShots
//
//  Created by mahendran-14703 on 28/11/22.
//

import Foundation

struct Constants {
    
    // MARK: IMAGES SAVING CONSTANTS
    static let postSavingFormat = "_POST_"
    static let dpSavingFormat = "DP_"
    static let noDPSavingFormat = "Default"
    
    // MARK: LOGGED IN USER CONSTANTS
    static let loggedUserFormat = "CurrentLoggedUser"
    
    // MARK: WARNING CONSTANTS
    static let unregisteredPhoneNumberWarning = "This phone number is not associated with any account"
    
    // MARK: USERNAME CONSTANTS
    static let userNameLength = "3-15"
    static let miniumUsernameLength = 3
    static let maximumUsernameLength = 15
    
    // MARK: PHONE NUMBER CONSTANTS
    static let phoneNumberLength = "8-15"
    static let minimumPhoneNumberLength = 8
    static let maximumPhoneNumberLength = 15
    
    // MARK: PASSWORD CONSTANTS
    static let minimumPasswordLength = 3
}
