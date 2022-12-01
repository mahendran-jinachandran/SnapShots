//
//  OnboardingControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingControls {
    
    private lazy var userDao: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func updateProfilePhoto(profilePhoto: UIImage) {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let photoName = AppUtility.getProfilePhotoSavingFormat(userID: loggedUserID)
        profilePhoto.saveImage(imageName: photoName,image: profilePhoto)
        
        if userDao.updatePhoto(photo: photoName, userID: loggedUserID) {
            // MARK: PROFILE PHOTO IS UPDATED
        } else {
            // MARK: COULDN'T UPLOAD PHOTO
        }
    }
    
    func updateEmail(email: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if !AppUtility.isValidEmail(email){
            return false
        }
        
        if userDao.updateMail(mailID: email, userID: loggedUserID) {
            // MARK: EMAIL IS UPDATED
        } else {
            // MARK: COULDN'T UPDATE
        }
        
        return true
    }
    
    func updateGender(gender: String) {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if userDao.updateGender(gender: gender, userID: loggedUserID) {
            // MARK: GENDER IS UPDATED
        } else {
            // MARK: COULDN'T UPDATE
        }
    }
    
    func updateBirthday(birthday: String) {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if userDao.updateAge(age: birthday, userID: loggedUserID) {
            // MARK: AGE IS UPDATED
        } else {
            // MARK: COULDN'T UPDATE
        }
    }
    
    func updateBio(bio: String) {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if userDao.updateBio(profileBio: bio, userID: loggedUserID){
            // MARK: AGE IS UPDATED
        } else {
            // MARK: COULDN'T UPDATE
        }
    }
}
