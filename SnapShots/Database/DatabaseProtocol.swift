//
//  DatabaseProtocol.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

protocol DatabaseProtocol {
    func retrievingQuery(query: String) -> [Int: [String]]
    func booleanQuery(query: String) -> Bool
    func execute(query: String) -> Bool
}
