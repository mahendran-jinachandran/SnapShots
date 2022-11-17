//
//  KeyboardTestVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/11/22.
//

import UIKit

class KeyboardTestVC: UIViewController {
    
    private var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupView()
    }
    
    private func setupView() {
//        textField = UITextField(frame: .zero)
//        textField.backgroundColor = .red
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(textField)
//        
//        textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        view.keyboardLayoutGuide.setConstraints([
//            textField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
//        ], activeWhenAwayFrom: .bottom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
}
