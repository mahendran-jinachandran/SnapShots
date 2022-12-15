//
//  EditProfileVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/12/22.
//

import UIKit

class EditProfileVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    private var username: String
    private var bio: String
    private var editProfileControls: EditProfileControlsProtocol
    private var userID: Int
    
    init(editProfileControls: EditProfileControlsProtocol,userID: Int,username: String, bio: String) {
        self.editProfileControls = editProfileControls
        self.username = username
        self.bio = bio
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var scrollContainer: UIView = {
        let scrollContainer = UIView()
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContainer.backgroundColor = .systemBackground
        return scrollContainer
    }()
    
    private lazy var usernameTextField: UITextField = {
        let usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.text = username
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive  = true
        usernameTextField.clearButtonMode = .whileEditing
        usernameTextField.setImageInTextFieldOnLeft(imageName: "personIcon")
        return usernameTextField
    }()
    
    private lazy var usernameWarningLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "Wrong"
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textColor = .red
        usernameLabel.font = UIFont.systemFont(ofSize: 12)
        usernameLabel.isHidden = true
        return usernameLabel
    }()
    
    private lazy var profileBioTextView: UITextView = {
        let bioProfile = UITextView()
        bioProfile.textColor = UIColor(named: "appTheme")
        bioProfile.text = bio
        bioProfile.font = UIFont.systemFont(ofSize: 16)
        bioProfile.translatesAutoresizingMaskIntoConstraints = false
        bioProfile.layer.borderWidth = 2.0
        bioProfile.layer.borderColor = UIColor.lightGray.cgColor
        return bioProfile
    }()
    
    private lazy var maximumBioLength: UILabel = {
        let maximumBioLength = UILabel()
        maximumBioLength.text = "Maximum character limit reached"
        maximumBioLength.translatesAutoresizingMaskIntoConstraints = false
        maximumBioLength.textColor = .red
        maximumBioLength.font = UIFont.systemFont(ofSize: 10)
        maximumBioLength.isHidden = true
        maximumBioLength.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return maximumBioLength
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        view.backgroundColor = .systemBackground

        setConstraints()
        showUpdateButton(isShown: true)
        usernameTextField.delegate = self
        profileBioTextView.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text! != username && !checkUsernameValidation(username: textField.text!) {
            showUpdateButton(isShown: false)
            return
        }

        showUpdateButton(isShown: true)
    }
    
    private func showUpdateButton(isShown: Bool) {
        
        if isShown {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateProfileDetails))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func updateProfileDetails() {
     
        if !editProfileControls.updateProfileDetails(username: usernameTextField.text!, profileBio: profileBioTextView.text!) {
            showToast(message: Constants.toastFailureStatus)
            return
        }
        
        NotificationCenter.default.post(name: Constants.userDetailsEvent, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func checkUsernameValidation(username: String) -> Bool {
        let usernameDetails = editProfileControls.validateUsername(username: username)
        
        if usernameDetails == .success(true) {
            validUserName()
            return true
        }
        else if usernameDetails == .success(false) {
            invalidUserName(warningLabel: UsernameError.alreadyTaken.description)
        }
        else if usernameDetails == .failure(.cannotBeEmpty) {
            invalidUserName(warningLabel: UsernameError.cannotBeEmpty.description)
        }
        else if usernameDetails  == .failure(.invalidNumberOfCharacters) {
            invalidUserName(warningLabel: UsernameError.invalidNumberOfCharacters.description)
        }
        
        return false
    }
    
    private func validUserName() {
        usernameWarningLabel.isHidden = true
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func invalidUserName(warningLabel: String) {
        usernameTextField.layer.borderColor = UIColor.red.cgColor
        usernameWarningLabel.isHidden = false
        usernameWarningLabel.text = warningLabel
    }
    
    func setConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [usernameTextField,usernameWarningLabel,maximumBioLength,profileBioTextView].forEach {
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
            
            usernameTextField.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant:60),
            usernameTextField.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 40),
            usernameTextField.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -40),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            usernameWarningLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor,constant: 8),
            usernameWarningLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 40),
            usernameWarningLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -40),
            
            profileBioTextView.topAnchor.constraint(equalTo: usernameWarningLabel.bottomAnchor,constant: 20),
            profileBioTextView.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 40),
            profileBioTextView.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -40),
            profileBioTextView.heightAnchor.constraint(equalToConstant: 100),
            profileBioTextView.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            
            maximumBioLength.topAnchor.constraint(equalTo: profileBioTextView.bottomAnchor,constant: 8),
            maximumBioLength.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        ])
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count < 70 && newText.count > 0 {
            profileBioTextView.layer.borderColor = UIColor(named: "appTheme")?.cgColor
            maximumBioLength.isHidden = true
            return true
        } else {
            maximumBioLength.isHidden = false
            return false
        }
    }
}
