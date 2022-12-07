//
//  ChangePasswordViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 20/11/22.
//

import UIKit

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {
    
    private lazy var currentPassword: UITextField = {
        let currentPassword = UITextField()
        currentPassword.placeholder = "Current Password"
        currentPassword.layer.cornerRadius = 10
        currentPassword.layer.borderWidth = 2
        currentPassword.layer.borderColor = UIColor.lightGray.cgColor
        currentPassword.translatesAutoresizingMaskIntoConstraints = false
        currentPassword.isSecureTextEntry = true
        currentPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: currentPassword.frame.height))
        currentPassword.leftViewMode = .always
        return currentPassword
    }()
    
    private lazy var currentPasswordIncorrectLabel: UILabel = {
       let oldPasswordIncorrect = UILabel()
        oldPasswordIncorrect.text = "Password is incorrect"
        oldPasswordIncorrect.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordIncorrect.textColor = .red
        oldPasswordIncorrect.isHidden = true
        oldPasswordIncorrect.font = UIFont.systemFont(ofSize: 16)
       return oldPasswordIncorrect
    }()
    
    private lazy var newPassword: UITextField = {
        let newPassword = UITextField()
        newPassword.placeholder = "New Password"
        newPassword.layer.cornerRadius = 10
        newPassword.layer.borderWidth = 2
        newPassword.layer.borderColor = UIColor.lightGray.cgColor
        newPassword.translatesAutoresizingMaskIntoConstraints = false
        newPassword.isSecureTextEntry = true
        newPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: newPassword.frame.height))
        newPassword.leftViewMode = .always
        return newPassword
    }()
    
    private lazy var againNewPassword: UITextField = {
        let againNewPassword = UITextField()
        againNewPassword.placeholder = "Again New Password"
        againNewPassword.layer.cornerRadius = 10
        againNewPassword.layer.borderWidth = 2
        againNewPassword.layer.borderColor = UIColor.lightGray.cgColor
        againNewPassword.translatesAutoresizingMaskIntoConstraints = false
        againNewPassword.isSecureTextEntry = true
        againNewPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: againNewPassword.frame.height))
        againNewPassword.leftViewMode = .always
        return againNewPassword
    }()
    
    private lazy var newPasswordsMismatchLabel: UILabel = {
       let newPasswordsMismatch = UILabel()
        newPasswordsMismatch.text = "Passwords do not match"
        newPasswordsMismatch.translatesAutoresizingMaskIntoConstraints = false
        newPasswordsMismatch.textColor = .red
        newPasswordsMismatch.font = UIFont.systemFont(ofSize: 12)
        newPasswordsMismatch.isHidden = true
       return newPasswordsMismatch
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Password"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        saveButton.addTarget(self, action: #selector(saveDetails), for: .touchUpInside)
        currentPassword.delegate = self
        newPassword.delegate = self
        againNewPassword.delegate = self
        
        setConstraints()
    }
    
    var isCurrentPasswordEntered: Bool = false
    var isNewPasswordEntered: Bool = false
    var isNewPasswordAgainEntered: Bool = false
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == currentPassword {
            if textField.text!.isEmpty || !SecurityController().isPasswordCorrect(password: textField.text!) {
                isCurrentPasswordEntered = false
                invalidCurrentPasswordStatus(warningLabel: "Wrong password")
            } else {
                isCurrentPasswordEntered = true
                validCurrentPasswordStatus()
                currentPasswordIncorrectLabel.isHidden = true
            }
        }
        
        if textField == newPassword {

            if textField.text!.count < Constants.minimumPasswordLength {
                isNewPasswordEntered = false
                invalidPasswordStatus(warningLabel: PasswordActionError.lessCharacters.description)
            } else {
                validPasswordStatus()
                isNewPasswordEntered = true
            }
        }
        
        if textField == againNewPassword {
            
            if !checkForPasswordMatch(password: newPassword.text, rePassword: againNewPassword.text) {
                isNewPasswordAgainEntered = false
            } else {
                validPasswordStatus()
                isNewPasswordAgainEntered = true
            }
        }
        
        if isCurrentPasswordEntered && isNewPasswordEntered && isNewPasswordAgainEntered {
            saveButton.alpha = 1.0
            saveButton.isEnabled = true
        } else {
            saveButton.alpha = 0.5
            saveButton.isEnabled = false
        }
    }
    
    @objc func saveDetails() {
        SecurityController().updatePassword(password: newPassword.text!)
        navigationController?.popViewController(animated: true)
    }
    
    func setConstraints() {
        
        [currentPassword,currentPasswordIncorrectLabel,newPassword,againNewPassword,newPasswordsMismatchLabel].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            currentPassword.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            currentPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            currentPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            currentPassword.heightAnchor.constraint(equalToConstant: 50),
            
            currentPasswordIncorrectLabel.topAnchor.constraint(equalTo: currentPassword.bottomAnchor,constant: 10),
            currentPasswordIncorrectLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            currentPasswordIncorrectLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            currentPasswordIncorrectLabel.heightAnchor.constraint(equalToConstant: 20),
            
            newPassword.topAnchor.constraint(equalTo: currentPasswordIncorrectLabel.bottomAnchor,constant: 20),
            newPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            newPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            newPassword.heightAnchor.constraint(equalToConstant: 50),

            againNewPassword.topAnchor.constraint(equalTo: newPassword.bottomAnchor,constant: 20),
            againNewPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            againNewPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            againNewPassword.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordsMismatchLabel.topAnchor.constraint(equalTo: againNewPassword.bottomAnchor,constant: 10),
            newPasswordsMismatchLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            newPasswordsMismatchLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            newPasswordsMismatchLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func invalidPasswordStatus(warningLabel: String) {
        newPasswordsMismatchLabel.text = warningLabel
        newPasswordsMismatchLabel.isHidden = false
    }
    
    func validPasswordStatus() {
        newPasswordsMismatchLabel.isHidden = true
    }
    
    func invalidCurrentPasswordStatus(warningLabel: String) {
        currentPasswordIncorrectLabel.text = warningLabel
        currentPasswordIncorrectLabel.isHidden = false
    }
    
    func validCurrentPasswordStatus() {
        currentPasswordIncorrectLabel.isHidden = true
    }
    
    func checkForPasswordMatch(password: String?,rePassword: String?) -> Bool {
        
        if password == rePassword {
            newPasswordsMismatchLabel.isHidden = true
            return true
        }
        
        newPasswordsMismatchLabel.isHidden = false
        invalidPasswordStatus(warningLabel: PasswordActionError.mismatch.description)
        return false
    }
}
