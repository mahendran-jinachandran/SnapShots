//
//  UIButtonExtension.swift
//  SnapShots
//
//  Created by mahendran-14703 on 03/01/23.
//

import UIKit

extension UIButton {
    func updateExpandAndCollapseStateAnimation(isExpanded: Bool) {
        
        let ANIM_DUR = 0.5
        let ROTATION_ANGLE = isExpanded ? 0.0 : 3.14
      
        UIView.animate(withDuration: ANIM_DUR, animations: {
            self.transform = CGAffineTransform(rotationAngle: ROTATION_ANGLE).inverted()
        })
    }
}
