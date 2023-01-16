//
//  PersonalInformationViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 21/11/22.
//

import UIKit

class PersonalInformationVC: UIViewController {
    
    private var accountControls: AccountControlsProtocol
    init(accountControls: AccountControlsProtocol) {
        self.accountControls = accountControls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
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
        emailLabel.alpha = 0.75
        return emailLabel
    }()
    
    private lazy var email: UILabel = {
        let email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
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
        phoneLabel.alpha = 0.75
        return phoneLabel
    }()
    
    private lazy var phone: UILabel = {
      let phone = UILabel()
        phone.translatesAutoresizingMaskIntoConstraints = false
        phone.textColor = UIColor(named: "appTheme")
        phone.font = UIFont.systemFont(ofSize: 18)
        phone.isUserInteractionEnabled = true
        return phone
    }()
    
    private lazy var genderLabel: UILabel = {
      let genderLabel = UILabel()
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.text = "Gender"
        genderLabel.textColor = UIColor(named: "appTheme")
        genderLabel.font = UIFont.systemFont(ofSize: 18)
        genderLabel.alpha = 0.75
        return genderLabel
    }()
    
    private lazy var gender: UILabel = {
      let gender = UILabel()
        gender.translatesAutoresizingMaskIntoConstraints = false
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
        dateOfBirthLabel.alpha = 0.75
        return dateOfBirthLabel
    }()
    
    private lazy var dateOfBirth: UILabel = {
      let dateOfBirth = UILabel()
        dateOfBirth.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirth.textColor = UIColor(named: "appTheme")
        dateOfBirth.font = UIFont.systemFont(ofSize: 18)
        dateOfBirth.isUserInteractionEnabled = true
        return dateOfBirth
    }()
    
    private lazy var accountCreatedDate: UILabel = {
        var accountCreatedDate = UILabel()
        accountCreatedDate.translatesAutoresizingMaskIntoConstraints = false
        accountCreatedDate.font = UIFont.systemFont(ofSize: 10)
        accountCreatedDate.textAlignment = .center
        return accountCreatedDate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setConstraints()
        setupTapGestures()
        setupNotificationCenter()
        updatePersonalInformation()
    }
    
    private func setupNotificationCenter() {
    //    NotificationCenter.default.addObserver(self, selector: #selector(updatePersonalInformation), name: Constants.profileDetailsEvent, object: nil)
    }
    
   @objc func updatePersonalInformation() {
       let user = accountControls.getUserDetails()
       email.text = user.mail == "-1" ? Constants.EMPTY : user.mail
       phone.text = user.phoneNumber
       gender.text = user.gender == .preferNotSay ? Gender.preferNotSay.description : user.gender == .male ? Gender.male.description : Gender.female.description
       dateOfBirth.text = user.age == "-1" ? Constants.EMPTY : user.age
       accountCreatedDate.text = "Account created on \(String(AppUtility.getDate(date: user.accountCreatedDate)))"
    }
    
    private func setupNavigationItems() {
        title = "Personal Information"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupTapGestures() {
 
        email.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(editMail(_:)))
        )

        gender.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(editGender(_:)))
        )
        
        dateOfBirth.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(editDateOfBirth(_:)))
        )
        
        phone.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(editPhoneNumber(_:)))
        )
    }

    @objc private func editMail(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(MailVC(accountControls: accountControls,mail: email.text!), animated: true)
    }
    
    @objc private func editGender(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(GenderVC(accountControls: accountControls,gender: gender.text!), animated: true)
    }
    
    @objc private func editDateOfBirth(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(DataOfBirthVC(accountControls: accountControls,dateOfBirth: dateOfBirth.text!), animated: true)
    }
    
    @objc func editPhoneNumber(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(PhoneNumberVC(accountControls: accountControls,phoneNumber: phone.text!) ,animated: true)
    }
        
    private func setConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [infoLabel,safetyWarningLabel,emailLabel,email,phoneLabel,phone,genderLabel,gender,dateOfBirthLabel,dateOfBirth,accountCreatedDate].forEach {
            scrollContainer.addSubview($0)
        }
        
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

            accountCreatedDate.topAnchor.constraint(equalTo: dateOfBirth.bottomAnchor,constant: 24),
            accountCreatedDate.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            accountCreatedDate.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -10),
            accountCreatedDate.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor,constant: -5),
        ])
    }
}
