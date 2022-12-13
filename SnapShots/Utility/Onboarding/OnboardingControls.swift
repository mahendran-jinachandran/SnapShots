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
        return AppUtility.updateEmail(email: email)
    }
    
    func updateGender(gender: String) -> Bool {
        return AppUtility.updateGender(gender: gender)
    }
    
    func updateBirthday(birthday: String) -> Bool {
        return AppUtility.updateBirthday(birthday: birthday)
    }
    
    func updateBio(bio: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDao.updateBio(profileBio: bio, userID: loggedUserID)
    }
}
