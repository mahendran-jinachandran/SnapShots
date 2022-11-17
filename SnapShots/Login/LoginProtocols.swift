//
//  LoginProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol LoginInteractorProtocol {
    func validatePhoneNumber(phoneNumber: String?)
    func isLoginCredentialsValid(phoneNumber: String,password: String)
}

protocol LoginPresenterProtocol {
    func phoneNumberExist(isPresent: Bool)
}

protocol ViewControllerProtocol {
    func verifyPhoneNumber(isVerified: Bool)
    func validCred() 
}
