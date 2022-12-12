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
    static let toastFailureStatus = "Error: Try again"
    
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
    
    // MARK: NOTIFICATION CENTER
    static let publishPostEvent = Notification.Name("Publish_Post") // Changes in the Post
    static let userDetailsEvent = Notification.Name("UserDetails_Modify") // Changes in the user details
    static let profileDetailsEvent = Notification.Name("ProfileDetails_Modify") // Regarding Profile details
    
    // MARK: NO BIO CONSTANT
    static let noUserBioDefault = "Nothing to share!"
}
