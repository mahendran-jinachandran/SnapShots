//
//  ListTableProtocols.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/01/23.
//

import Foundation

protocol ListTableProtocol {
    func getBlockedUsers() -> [User]
    func unblockTheUser(unblockingUserID: Int) -> Bool
}
