//
//  LoginRouter.swift
//  SnapShots
//
//  Created by mahendran-14703 on 27/03/23.
//

import Foundation
import UIKit

class LoginRouter {
    
    func routeToHomePage() {
        print(#function)
        // MARK: ROUTE TO HOME PAGE
        
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        
        window?.rootViewController = HomePageViewController()
       
    }
    
    func routeToRegisterPage() {
        print(#function)
        // MARK: ROUTE TO REGISTER PAGE
    }
    
    func routeToForgotPasswordPage() {
        print(#function)
        // MARK: ROUTE TO FORGOT PASSWORD PAG
    }
}
