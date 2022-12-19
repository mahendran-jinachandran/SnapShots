//
//  UITabBarExtension.swift
//  SnapShots
//
//  Created by mahendran-14703 on 19/12/22.
//

import UIKit

extension UITabBar {
    
    func changeBadgeValue(value: Int) {
         if let tabItems = self.items {
             let tabItem = tabItems[2]
             
             if value == 0 {
                 tabItem.badgeValue = nil
             } else {
                 tabItem.badgeValue = "\(value)"
             }
         }
     }
}
