//
//  LoginProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol LoginControllerProtocol {
    func validatePhoneNumber(phoneNumber: String)
    func validateUserCredentials(phoneNumber: String,password: String)
}

protocol LoginViewProtocol: AnyObject {
    func displayPhoneNumberVerificationState(isVerified: Bool)
    func displayWrongCredentials()
    func goToHomePage()
}
