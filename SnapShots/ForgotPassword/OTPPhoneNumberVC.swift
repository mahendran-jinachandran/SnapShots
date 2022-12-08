//
//  PhoneNumberVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class OTPPhoneNumberVC: UIViewController,UITextFieldDelegate {
    
    private lazy var phoneNumberLabel: UILabel = {
        var phoneNumber = UILabel()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.text = "Enter your registered \n\tphone number"
        phoneNumber.textColor = UIColor(named: "appTheme")
        phoneNumber.font = UIFont.boldSystemFont(ofSize: 20)
        phoneNumber.numberOfLines = 2
        return phoneNumber
    }()
    
    private lazy var phoneNumber: UITextField = {
        let phoneNumber = UITextField()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.placeholder = "Phone number"
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.clearButtonMode = .whileEditing
        phoneNumber.keyboardType = .numberPad
        phoneNumber.setImageInTextFieldOnLeft(imageName: "smartPhone.png")
        return phoneNumber
    }()
    
    private lazy var sendOTPButton: UIButton = {
       var sendOTPButton = UIButton()
        sendOTPButton.translatesAutoresizingMaskIntoConstraints = false
        sendOTPButton.setTitle("Send OTP", for: .normal)
        sendOTPButton.setTitleColor(.systemBackground, for: .normal)
        sendOTPButton.backgroundColor = UIColor(named: "appTheme")
        sendOTPButton.layer.cornerRadius = 5
        return sendOTPButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        [phoneNumberLabel,phoneNumber,sendOTPButton].forEach {
            view.addSubview($0)
        }
        
        phoneNumber.delegate = self
        setupConstraints()
        
        sendOTPButton.addTarget(self, action: #selector(sendOTP), for: .touchUpInside)
    }
    
    @objc func sendOTP() {
        
        if let phoneNumber = phoneNumber.text,!phoneNumber.isEmpty {
            AuthManager.shared.startAuth(phoneNumber: "+91\(phoneNumber)") { [weak self] success in
                
                if !success {
                    return
                }

                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(OTPScreenVC(), animated: false)
                }
            }
        }
    }

    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        
        return self.textLimit(existingText: textField.text,newText: string,limit: 10)
    }

    private func textLimit(existingText: String?,newText: String,limit: Int) -> Bool {
        let text = existingText ?? ""
        return text.count + newText.count <= limit
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            phoneNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            phoneNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberLabel.heightAnchor.constraint(equalToConstant: 60),
            phoneNumberLabel.widthAnchor.constraint(equalToConstant: 200),
            
            phoneNumber.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor,constant: 20),
            phoneNumber.heightAnchor.constraint(equalToConstant: 50),
            phoneNumber.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            phoneNumber.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            
            sendOTPButton.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor,constant: 20),
            sendOTPButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendOTPButton.heightAnchor.constraint(equalToConstant: 40),
            sendOTPButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
