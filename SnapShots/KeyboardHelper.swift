//
//  KeyboardHelper.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import Foundation
import UIKit

struct Keyboard {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
