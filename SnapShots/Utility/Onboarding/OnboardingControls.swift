//
//  OnboardingControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingControls: OnboardingProtocol {
    
    private lazy var userDao: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func updateProfilePhoto(profilePhoto: UIImage) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let photoName = AppUtility.getProfilePhotoSavingFormat(userID: loggedUserID)
        profilePhoto.saveImage(imageName: photoName,image: profilePhoto)
        
        return userDao.updatePhoto(photo: photoName, userID: loggedUserID) 
    }
    
    func updateEmail(email: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if !AppUtility.isValidEmail(email){
            return false
        }
        
        return userDao.updateMail(mailID: email, userID: loggedUserID)
    }
    
    func updateGender(gender: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDao.updateGender(gender: gender, userID: loggedUserID)
    }
    
    func updateBirthday(birthday: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDao.updateAge(age: birthday, userID: loggedUserID) 
    }
    
    func updateBio(bio: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDao.updateBio(profileBio: bio, userID: loggedUserID)
   
    }
}
