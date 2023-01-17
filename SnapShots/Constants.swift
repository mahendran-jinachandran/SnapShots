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
    static let updatePostEvent = Notification.Name("updatePost") // UPDATING A POST
    static let likePostEvent = Notification.Name("likePost") // LIKING THE POST
    static let unlikePostEvent = Notification.Name("unlikePost") // UNLIKING THE POST
    static let insertCommentPostEvent = Notification.Name("insertComment") // INSERTING A COMMENT
    static let deleteCommentPostEvent = Notification.Name("deleteComment") // DELETING A COMMENT
    static let updateUserEvent = Notification.Name("updateUser") // UPDATE USER
    static let addFriendPostEvent = Notification.Name("addFriendPost") // ADDING FRIEND'S POST TO THE FEEDS AFTER ACCEPTING REQUEST
    static let removeFriendPostEvent = Notification.Name("removeFriendPost") // REMOVING FRIEND'S POST FROM THE FEEDS AFTER UNFOLLOWING
    static let blockUserEvent = Notification.Name("blockUser") // BLOCKING AN USER
    static let unblockingUserEvent = Notification.Name("unblockUser") // UNBLOCKING AN USER
    static let savingPostEvent = Notification.Name("savingPost") // SAVING A POST
    static let unsavingPostEvent = Notification.Name("unSavingPost") // UNSAVING A POST
}
