//
//  LoginPresenter.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class LoginPresenter: LoginPresenterProtocol {
    
    var loginViewController: LoginViewController?
    
    func phoneNumberExist(isPresent: Bool) {
        loginViewController?.validCred()
    }
}
