//
//  User.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation

class User {
    var userID: Int
    var userName: String
    var password: String
    var phoneNumber: String
    var gender: Gender
    var age: String
    var mail: String
    var accountCreatedDate: String
    var profile: Profile
    
    init(userId: Int,userName: String, password: String, phoneNumber: String, gender: Gender, age: String, mail: String,photo: String,bio: String,accountCreatedDate: String) {
        
        self.userID = userId
        self.userName = userName
        self.password = password
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.age = age
        self.mail = mail
        self.accountCreatedDate = accountCreatedDate
        profile = Profile()
        profile.bio = bio
        profile.photo = photo
    }
}
