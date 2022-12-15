//
//  SubClass.swift
//  SnapShots
//
//  Created by mahendran-14703 on 15/12/22.
//

import UIKit

class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender)
        return false
    }
}
