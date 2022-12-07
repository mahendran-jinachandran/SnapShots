//
//  OnboardingProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol OnboardingProtocol {
    func updateProfilePhoto(profilePhoto: UIImage)
    func updateEmail(email: String) -> Bool
    func updateGender(gender: String)
    func updateBirthday(birthday: String)
    func updateBio(bio: String)
}
