//
//  ChangePasswordViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 20/11/22.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    private lazy var oldPassword: UITextField = {
        let oldPassword = UITextField()
        oldPassword.placeholder = "Old Password"
        oldPassword.layer.cornerRadius = 10
        oldPassword.layer.borderWidth = 2
        oldPassword.layer.borderColor = UIColor.lightGray.cgColor
        oldPassword.translatesAutoresizingMaskIntoConstraints = false
        oldPassword.isSecureTextEntry = true
        oldPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: oldPassword.frame.height))
        oldPassword.leftViewMode = .always
        return oldPassword
    }()
    
    private lazy var oldPasswordIncorrect: UILabel = {
       let oldPasswordIncorrect = UILabel()
        oldPasswordIncorrect.text = "Password is incorrect"
        oldPasswordIncorrect.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordIncorrect.textColor = .red
        oldPasswordIncorrect.isHidden = false
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
    
    private lazy var newPasswordsMismatch: UILabel = {
       let newPasswordsMismatch = UILabel()
        newPasswordsMismatch.text = "Passwords do not match"
        newPasswordsMismatch.translatesAutoresizingMaskIntoConstraints = false
        newPasswordsMismatch.textColor = .red
        newPasswordsMismatch.isHidden = false
       return newPasswordsMismatch
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Password"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.addTarget(self, action: #selector(saveDetails), for: .touchUpInside)
        
        [oldPassword,oldPasswordIncorrect,newPassword,againNewPassword,newPasswordsMismatch].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
    }
    
    @objc func saveDetails() {
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            oldPassword.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            oldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            oldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            oldPassword.heightAnchor.constraint(equalToConstant: 50),
            
            oldPasswordIncorrect.topAnchor.constraint(equalTo: oldPassword.bottomAnchor,constant: 10),
            oldPasswordIncorrect.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            oldPasswordIncorrect.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            oldPasswordIncorrect.heightAnchor.constraint(equalToConstant: 20),
            
            newPassword.topAnchor.constraint(equalTo: oldPasswordIncorrect.bottomAnchor,constant: 20),
            newPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            newPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            newPassword.heightAnchor.constraint(equalToConstant: 50),

            againNewPassword.topAnchor.constraint(equalTo: newPassword.bottomAnchor,constant: 20),
            againNewPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            againNewPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            againNewPassword.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordsMismatch.topAnchor.constraint(equalTo: againNewPassword.bottomAnchor,constant: 10),
            newPasswordsMismatch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            newPasswordsMismatch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            newPasswordsMismatch.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
