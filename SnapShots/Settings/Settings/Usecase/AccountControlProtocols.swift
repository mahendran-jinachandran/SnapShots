//
//  AccountControlProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 12/12/22.
//

import Foundation


protocol AccountControlsProtocol {
    func getuserDetails() -> User
    func updateEmail(email: String) -> Bool
    func updateGender(gender: String) -> Bool
    func updateBirthday(birthday: String) -> Bool
    func validatePhoneNumber(phoneNumber: String) -> Result<Bool,PhoneNumberError>
    func updatePhoneNumber(phoneNumber: String) -> Bool
    func deleteAccount() -> Bool
}
