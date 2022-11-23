//
//  RegisterProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 17/11/22.
//

import Foundation

protocol RegisterViewProtocol {

}

protocol RegisterControllerProtocol {
    func executeRegistrationProcess(username: String,phoneNumber: String,password: String)
    func isUserNameTaken(username: String) -> Bool
    func isValidPhoneNumber(phoneNumber: String) -> Bool
}
