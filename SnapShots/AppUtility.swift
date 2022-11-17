//
//  AppUtility.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation
import UIKit

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
        
    }
}
