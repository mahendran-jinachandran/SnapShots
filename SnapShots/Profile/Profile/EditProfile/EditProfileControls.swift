//
//  EditProfileControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/12/22.
//

import Foundation

class EditProfileControls: EditProfileControlsProtocol {
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func validateUsername(username: String) -> Result<Bool,UsernameError> {
        return AppUtility.validateUsername(username: username)
    }
    
    func updateProfileDetails(username: String,profileBio: String) {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        if userDaoImp.updateUsername(username: username, userID: loggedUserID) {
            print("Update username")
        } else {
            print("Could not update username")
        }
        
        let profileBio = profileBio.count > 0 ? profileBio : Constants.noUserBioDefault
        if userDaoImp.updateBio(profileBio: profileBio, userID: loggedUserID) {
            print("Update Bio")
        } else {
            print("Could not update Bio")
        }
    }
}
