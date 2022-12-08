//
//  OnboardingProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol OnboardingProtocol {
    func updateProfilePhoto(profilePhoto: UIImage) -> Bool
    func updateEmail(email: String) -> Bool
    func updateGender(gender: String) -> Bool
    func updateBirthday(birthday: String) -> Bool
    func updateBio(bio: String) -> Bool
}
