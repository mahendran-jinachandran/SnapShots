//
//  OTPScreenVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class OTPScreenVC: UIViewController,UITextFieldDelegate {
    
    var phoneNumber: String
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private lazy var otpCheckButton: UIButton = {
        let otpCheckButton = UIButton()
        otpCheckButton.setTitle("Check OTP", for: .normal)
        otpCheckButton.backgroundColor = .systemBlue
        otpCheckButton.layer.cornerRadius = 10
        otpCheckButton.translatesAutoresizingMaskIntoConstraints = false
        otpCheckButton.isEnabled = false
        otpCheckButton.alpha = 0.5
        return otpCheckButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        otpCheckButton.addTarget(self, action: #selector(validateOTP), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        [otpTextField,otpCheckButton].forEach {
            view.addSubview($0)
        }
        
        otpTextField.delegate = self
        setupConstraints()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if otpTextField.text?.count == 6 {
            otpCheckButton.isEnabled = true
            otpCheckButton.alpha = 1.0
        }
    }
    
    @objc func validateOTP() {
        if let text = otpTextField.text, !text.isEmpty {
            let code = text
            
            AuthManager.shared.verifyOTP(code: code) { [weak self] success in
                guard success else {
                    
                    let otpAlert=UIAlertController(title: "OTP", message: "Invalid OTP", preferredStyle: .alert)
                    
                    otpAlert.addAction(UIAlertAction(title: "Retry", style: .default){ _ in
                        OTPPhoneNumberVC().sendOTP()
                    })
                    
                    otpAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                       
                    self?.present(otpAlert, animated: true)
                    return
                }
                
                self?.navigationController?.pushViewController(OTPChangePasswordVC(phoneNumber: self!.phoneNumber), animated: true)

            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

            otpTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 60),
            otpTextField.heightAnchor.constraint(equalToConstant: 50),
            otpTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            otpTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            
            otpCheckButton.topAnchor.constraint(equalTo: otpTextField.bottomAnchor,constant: 20),
            otpCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpCheckButton.widthAnchor.constraint(equalToConstant: 150)
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
