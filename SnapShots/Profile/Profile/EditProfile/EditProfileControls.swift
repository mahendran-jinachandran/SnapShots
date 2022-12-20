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
    
    func updateProfileDetails(username: String,profileBio: String) -> Bool {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        let profileBio = profileBio.count > 0 ? profileBio : Constants.noUserBioDefault

        return userDaoImp.updateUsername(username: username.trimmingCharacters(in: .whitespacesAndNewlines), userID: loggedUserID) && userDaoImp.updateBio(profileBio: profileBio, userID: loggedUserID)
    }
}
