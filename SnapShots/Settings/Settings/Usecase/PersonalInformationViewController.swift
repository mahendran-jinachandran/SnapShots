//
//  PersonalInformationViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 21/11/22.
//

import UIKit

class PersonalInformationViewController: UIViewController {
    
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "Provide your personal information,even if the account is used for a business, a pet or something else. This won't be a part of your public profile."
        infoLabel.numberOfLines = 5
        infoLabel.textColor = .gray
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        return infoLabel
    }()
    
    private lazy var safetyWarningLabel: UILabel = {
        let safetyWarningLabel = UILabel()
        safetyWarningLabel.text = "To keep your account secure, don't enter an email or phone number that belongs to someone else."
        safetyWarningLabel.numberOfLines = 5
        safetyWarningLabel.textColor = .gray
        safetyWarningLabel.font = UIFont.systemFont(ofSize: 16)
        safetyWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        return safetyWarningLabel
    }()
    
    private lazy var emailLabel: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "Email"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        return email
    }()
    
    private lazy var email: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "mithu.dar@gmail.com"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        email.layer.borderWidth = 1.0
        email.layer.borderColor = UIColor(named: "mainPage")?.cgColor
        email.layer.cornerRadius = 5.0
        return email
    }()
    
    private lazy var phoneLabel: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "Phone"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        return email
    }()
    
    private lazy var phone: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "9884133730"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        return email
    }()
    
    private lazy var genderLabel: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "Gender"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        return email
    }()
    
    private lazy var gender: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "Male"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        return email
    }()
    
    private lazy var dateOfBirthLabel: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "Date of Birth"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        return email
    }()
    
    private lazy var dateOfBirth: UITextField = {
      let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "29-Aug-2000"
        email.textColor = UIColor(named: "mainPage")
        email.font = UIFont.systemFont(ofSize: 18)
        email.isUserInteractionEnabled = true
        return email
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Personal Information"
        
        [infoLabel,safetyWarningLabel,emailLabel,email,phoneLabel,phone,genderLabel,gender,dateOfBirthLabel,dateOfBirth].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            infoLabel.heightAnchor.constraint(equalToConstant: 80),
            
            safetyWarningLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            safetyWarningLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            safetyWarningLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            safetyWarningLabel.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: safetyWarningLabel.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            emailLabel.heightAnchor.constraint(equalToConstant: 44),
            
            email.topAnchor.constraint(equalTo: safetyWarningLabel.bottomAnchor, constant: 30),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            email.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            email.heightAnchor.constraint(equalToConstant: 44),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,constant: 30),
            phoneLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            phoneLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            phoneLabel.heightAnchor.constraint(equalToConstant: 44),
            
            phone.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 30),
            phone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            phone.leadingAnchor.constraint(equalTo: phoneLabel.trailingAnchor),
            phone.heightAnchor.constraint(equalToConstant: 44),
            
            genderLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor,constant: 30),
            genderLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            genderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            genderLabel.heightAnchor.constraint(equalToConstant: 44),
            
            gender.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 30),
            gender.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            gender.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor),
            gender.heightAnchor.constraint(equalToConstant: 44),
            
            dateOfBirthLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor,constant: 30),
            dateOfBirthLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            dateOfBirthLabel.heightAnchor.constraint(equalToConstant: 44),
            
            dateOfBirth.topAnchor.constraint(equalTo: gender.bottomAnchor, constant: 30),
            dateOfBirth.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            dateOfBirth.leadingAnchor.constraint(equalTo: dateOfBirthLabel.trailingAnchor),
            dateOfBirth.heightAnchor.constraint(equalToConstant: 44),
            
        ])
    }
}
