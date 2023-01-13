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
    static let blockEvent = Notification.Name("blockPeople") // Blocking People
    
    // MARK: NO BIO CONSTANT
    static let noUserBioDefault = "Nothing to share!"
    
    // MARK: GENERAL CONSTANTS
    static let MALE = "Male"
    static let FEMALE = "Female"
    static let PREFER_NOT_SAY = "Prefer Not Say"
    static let EMPTY = "Yet to fill"
    
    static let genders = [Constants.MALE,Constants.FEMALE,Constants.PREFER_NOT_SAY]
    static let notificationCenterKeyName = "Data"
    
    // MARK:  NOTIFICATION CENTER - EVENT BASED
    static let createPostEvent = Notification.Name("createPost") // CREATING A POST
    static let deletePostEvent = Notification.Name("deletePost") // DELETING A POST
    
//    static let archivePostEvent = Notification.Name("archivePost") // ARCHIVING A POST
//    static let unarchivePostEvent = Notification.Name("unarchivePost") // UNARCHIVING A POST
//
//    static let savePostEvent = Notification.Name("savePost") // SAVING A POST
//    static let unsavePostEvent = Notification.Name("unsavePost") // UNSAVING A POST
    
    static let updatePostEvent = Notification.Name("updatePost") // UPDATING A POST
    
    static let likePostEvent = Notification.Name("likePost") // LIKING THE POST
    
}
