//
//  EditProfileProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/12/22.
//

import Foundation

protocol EditProfileControlsProtocol {
    func validateUsername(username: String) -> Result<Bool,UsernameError>
    func updateProfileDetails(username: String,profileBio: String) -> Bool
}
