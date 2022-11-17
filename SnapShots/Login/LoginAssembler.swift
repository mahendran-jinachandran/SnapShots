//
//  LoginAssembler.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/11/22.
//

import Foundation

class LoginAssembler {
    
    static func assemble() -> LoginViewController {
        
       
        let loginInteractor = LoginInteractor()
        let loginViewController = LoginViewController(loginInteractor: loginInteractor)
        let loginPresenter = LoginPresenter()
       
        loginViewController.loginInteractor = loginInteractor
        loginInteractor.loginPresenter = loginPresenter
        loginPresenter.loginViewController = loginViewController
        
                
        return loginViewController
    }
    
}
