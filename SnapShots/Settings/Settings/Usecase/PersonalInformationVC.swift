//
//  PersonalInformationViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 21/11/22.
//

import UIKit

class PersonalInformationVC: UIViewController {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private lazy var scrollContainer: UIView = {
        let scrollContainer = UIView()
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContainer.backgroundColor = .systemBackground
        return scrollContainer
    }()
    
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
      let emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Email"
        emailLabel.textColor = UIColor(named: "appTheme")
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        return emailLabel
    }()
    
    private lazy var email: UILabel = {
      let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.text = "mithu.dar@gmail.com"
        email.textColor = UIColor(named: "appTheme")
        email.font = UIFont.systemFont(ofSize: 18)
        email.isUserInteractionEnabled = true
        return email
    }()
    
    private lazy var phoneLabel: UILabel = {
      let phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.text = "Phone"
        phoneLabel.textColor = UIColor(named: "appTheme")
        phoneLabel.font = UIFont.systemFont(ofSize: 18)
        return phoneLabel
    }()
    
    private lazy var phone: UILabel = {
      let phone = UILabel()
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.text = "9884133730"
        phone.textColor = UIColor(named: "appTheme")
        phone.font = UIFont.systemFont(ofSize: 18)
        return phone
    }()
    
    private lazy var genderLabel: UILabel = {
      let genderLabel = UILabel()
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.text = "Gender"
        genderLabel.textColor = UIColor(named: "appTheme")
        genderLabel.font = UIFont.systemFont(ofSize: 18)
        return genderLabel
    }()
    
    private lazy var gender: UILabel = {
      let gender = UILabel()
        gender.translatesAutoresizingMaskIntoConstraints = false
        gender.text = "Male"
        gender.textColor = UIColor(named: "appTheme")
        gender.font = UIFont.systemFont(ofSize: 18)
        gender.isUserInteractionEnabled = true
        return gender
    }()
    
    private lazy var dateOfBirthLabel: UILabel = {
      let dateOfBirthLabel = UILabel()
        dateOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthLabel.text = "Date of Birth"
        dateOfBirthLabel.textColor = UIColor(named: "appTheme")
        dateOfBirthLabel.font = UIFont.systemFont(ofSize: 18)
        return dateOfBirthLabel
    }()
    
    private lazy var dateOfBirth: UILabel = {
      let dateOfBirth = UILabel()
        dateOfBirth.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirth.text = "29-Aug-2000"
        dateOfBirth.textColor = UIColor(named: "appTheme")
        dateOfBirth.font = UIFont.systemFont(ofSize: 18)
        return dateOfBirth
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Personal Information"
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [infoLabel,safetyWarningLabel,emailLabel,email,phoneLabel,phone,genderLabel,gender,dateOfBirthLabel,dateOfBirth].forEach {
            scrollContainer.addSubview($0)
        }
        


        setConstraints()
        
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(editMail(_:)))
        email.addGestureRecognizer(emailTap)
        
        let genderTap = UITapGestureRecognizer(target: self, action: #selector(editGender(_:)))
        gender.addGestureRecognizer(genderTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = AccountControls().getuserDetails()
        email.text = user.mail
        phone.text = user.phoneNumber
        gender.text = user.gender == .male ? "Male" : "Female"
        dateOfBirth.text = user.age
    }
    
    @objc func editMail(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(MailVC(mail: email.text!), animated: true)
    }
    
    @objc func editGender(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(GenderVC(), animated: true)
    }
    
    
        
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -10),
            infoLabel.heightAnchor.constraint(equalToConstant: 80),
            
            safetyWarningLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            safetyWarningLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            safetyWarningLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -10),
            safetyWarningLabel.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: safetyWarningLabel.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 10),
            emailLabel.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.3),
            emailLabel.heightAnchor.constraint(equalToConstant: 40),
            
            email.topAnchor.constraint(equalTo: safetyWarningLabel.bottomAnchor, constant: 30),
            email.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -10),
            email.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            email.heightAnchor.constraint(equalToConstant: 40),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,constant: 10),
            phoneLabel.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.3),
            phoneLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            phoneLabel.heightAnchor.constraint(equalToConstant: 40),
            
            phone.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
            phone.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: 10),
            phone.leadingAnchor.constraint(equalTo: phoneLabel.trailingAnchor),
            phone.heightAnchor.constraint(equalToConstant: 40),
            
            genderLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor,constant: 10),
            genderLabel.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.3),
            genderLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            genderLabel.heightAnchor.constraint(equalToConstant: 40),
            
            gender.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 10),
            gender.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: 10),
            gender.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor),
            gender.heightAnchor.constraint(equalToConstant: 40),
            
            dateOfBirthLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor,constant: 10),
            dateOfBirthLabel.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.3),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            dateOfBirthLabel.heightAnchor.constraint(equalToConstant: 40),
            
            dateOfBirth.topAnchor.constraint(equalTo: gender.bottomAnchor, constant: 10),
            dateOfBirth.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: 10),
            dateOfBirth.leadingAnchor.constraint(equalTo: dateOfBirthLabel.trailingAnchor),
            dateOfBirth.heightAnchor.constraint(equalToConstant: 40),
            dateOfBirth.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor,constant: -2)
        ])
    }
}
