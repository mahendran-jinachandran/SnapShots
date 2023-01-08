//
//  UserDao.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol UserDao {
    func isPhoneNumberAlreadyExist(phoneNumber: String) -> Bool
    func isUsernameAlreadyExist(username: String) -> Bool
    func isPhotoPresent(userID: Int) -> Bool
    
    func getAllUsers() -> [User]
    func getUserDetails(phoneNumber: String,password: String) -> User?
    func getUserDetails(phoneNumber: String) -> User?
    func getUserDetails(userID: Int) -> User?
    func getUserID(phoneNumber: String,password: String) -> Int?
    
    func createNewUser(userName: String, password: String, phoneNumber: String) -> Bool
    func completeUserProfile(userID: Int, photo: String,gender: Gender,mailID: String,age: String) -> Bool

    func updatePassword(password: String,phoneNumber: String) -> Bool
    func updatePassword(password: String,userID: Int) -> Bool
    func updateUsername(username: String,userID: Int) -> Bool
    func updatePhoneNumber(phoneNumber: String,userID: Int) -> Bool
    func updateMail(mailID: String,userID: Int) -> Bool
    func updateGender(gender: String,userID: Int) -> Bool
    func updateAge(age: String,userID: Int) -> Bool
    func updatePhoto(photo: String,userID: Int) -> Bool
    func updateBio(profileBio: String,userID: Int) -> Bool
    
    func getUserBasedOnSearch(userName: String) -> [(userID: Int, userName: String)]
    func getUsername(userID: Int) -> String
    func getBio(userID: Int) -> String
    
    func deleteAccount(userID: Int) -> Bool
    
    
    func blockUser(loggedUserID: Int,userID: Int) -> Bool
}
