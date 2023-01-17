//
//  SearchProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/12/22.
//

import UIKit

protocol SearchControlsProtocol {
    func getAllUsers() -> [User]
    func getUser(userID: Int) -> User
}
