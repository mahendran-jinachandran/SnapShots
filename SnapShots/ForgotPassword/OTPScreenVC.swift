//
//  OTPScreenVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class OTPScreenVC: UIViewController,UITextFieldDelegate {
    
    private lazy var otpTextField: UITextField = {
        let phoneNumber = UITextField()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.placeholder = "OTP"
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.clearButtonMode = .whileEditing
        phoneNumber.keyboardType = .numberPad
        phoneNumber.setImageInTextFieldOnLeft(imageName: "smartPhone.png")
        return phoneNumber
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        [otpTextField].forEach {
            view.addSubview($0)
        }
        
        otpTextField.delegate = self
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
        
            otpTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 60),
            otpTextField.heightAnchor.constraint(equalToConstant: 50),
            otpTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            otpTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
        ])
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,newText: string,limit: 6)
    }

    private func textLimit(existingText: String?,newText: String,limit: Int) -> Bool {
        let text = existingText ?? ""
        return text.count + newText.count <= limit
    }
}
