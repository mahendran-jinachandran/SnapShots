//
//  SecurityControllerProtocol.swift
//  SnapShots
//
//  Created by mahendran-14703 on 22/12/22.
//

import Foundation

protocol ResetPasswordProtocol {
    func isPasswordCorrect(password: String) -> Bool
    func updatePassword(password: String) 
}
