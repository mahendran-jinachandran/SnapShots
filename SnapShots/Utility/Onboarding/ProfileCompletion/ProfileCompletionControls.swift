//
//  ProfileCompletionControls.swift
//  SnapShots
//
//  Created by mahendran-14703 on 22/11/22.
//

import Foundation


class ProfileCompletionControls: ProfileCompletionControlsProtocol {
    
    private weak var profileCompletionView: ProfileCompletionVC?
    
    private lazy var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)
    
    func finishProfileCompletion(photo: Int?,gender: Gender?,mailID: String?,age: Int?,bio: String?) {
        
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        
        if let gender = gender {
            _ = userDaoImp.updateGender(gender: gender.description, userID: userID)
        }
        
        if let mailID = mailID {
            _ = userDaoImp.updateMail(mailID: mailID, userID: userID)
        }
        
        if let age = age {
            _ = userDaoImp.updateAge(age: age, userID: userID)
        }
        
        if let bio = bio {
            _ = userDaoImp.updateBio(profileBio: bio, userID: userID)
        }
    
    }
}
