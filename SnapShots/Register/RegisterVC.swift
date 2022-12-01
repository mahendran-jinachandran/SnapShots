//
//  RegisterViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit

class RegisterVC: UIViewController,RegisterViewProtocol,UITextFieldDelegate {
    
    private var registerController: RegisterControllerProtocol!
    
    public func setController(_ registerController: RegisterControllerProtocol) {
        self.registerController = registerController
    }
    
    var registerStackView: UIStackView!
    let registerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    let registerLabel: UILabel = {
       let registerLabel = UILabel()
        registerLabel.text = "REGISTER"
       registerLabel.font =  UIFont(name: "Copperplate", size: 50)
        registerLabel.textColor = UIColor(named: "appTheme")
        registerLabel.textAlignment = .center
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.heightAnchor.constraint(equalToConstant: 180).isActive = true
       return registerLabel
    }()
    
    lazy var username: UITextField = {
        let username = UITextField()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.placeholder = "Username"
        username.layer.cornerRadius = 10
        username.layer.borderWidth = 2
        username.layer.borderColor = UIColor.lightGray.cgColor
        username.translatesAutoresizingMaskIntoConstraints = false
        username.heightAnchor.constraint(equalToConstant: 50).isActive  = true
        username.clearButtonMode = .whileEditing
        username.setImageInTextFieldOnLeft(imageName: "personIcon")
        return username
    }()
    
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "USER NAME IS ALREADY TAKEN."
        usernameLabel.textColor = .red
        usernameLabel.font = usernameLabel.font.withSize(10)
        usernameLabel.isHidden = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return usernameLabel
    }()
    
    lazy var phoneNumber: UITextField = {
        let phoneNumber = UITextField()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.placeholder = "Phone number"
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.heightAnchor.constraint(equalToConstant: 50).isActive  = true
        phoneNumber.clearButtonMode = .whileEditing
        phoneNumber.keyboardType = .numberPad
        phoneNumber.setImageInTextFieldOnLeft(imageName: "smartPhone.png")
        return phoneNumber
    }()
    
    lazy var phoneNumberLabel: UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.text = "PHONE NUMBER IS ALREADY ASSOCIATED WITH ANOTHER ACCOUNT"
        phoneNumberLabel.textColor = .red
        phoneNumberLabel.font = phoneNumberLabel.font.withSize(10)
        phoneNumberLabel.isHidden = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return phoneNumberLabel
    }()
    
    lazy var password: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.layer.cornerRadius = 10
        password.layer.borderWidth = 2
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.translatesAutoresizingMaskIntoConstraints = false
        password.heightAnchor.constraint(equalToConstant: 50).isActive  = true
        password.setImageInTextFieldOnLeft(imageName: "password.png")
        password.isSecureTextEntry = true
        password.rightViewMode = .always
        password.rightView = passwordVisibilityToggleButton
        return password
    }()
    
    
    lazy var rePassword: UITextField = {
        let rePassword = UITextField()
        rePassword.placeholder = "Re-enter password"
        rePassword.layer.cornerRadius = 10
        rePassword.layer.borderWidth = 2
        rePassword.layer.borderColor = UIColor.lightGray.cgColor
        rePassword.translatesAutoresizingMaskIntoConstraints = false
        rePassword.heightAnchor.constraint(equalToConstant: 50).isActive  = true
        rePassword.setImageInTextFieldOnLeft(imageName: "password.png")
        return rePassword
    }()
    
    lazy var passwordVisibilityToggleButton: UIButton = {
       let toggleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
       toggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
       toggleButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
       toggleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
       return toggleButton
    }()
    
    @objc func passwordVisibility(_ sender : UIButton) {
        if(password.isSecureTextEntry){
            password.isSecureTextEntry = false
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }else{
            password.isSecureTextEntry = true
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }
    }
    
    lazy var passwordNotMatchLabel: UILabel = {
        let passwordNotMatchLabel = UILabel()
        passwordNotMatchLabel.text = "PASSWORD DOES NOT MATCH"
        passwordNotMatchLabel.textColor = .red
        passwordNotMatchLabel.font = phoneNumberLabel.font.withSize(10)
        passwordNotMatchLabel.isHidden = true
        passwordNotMatchLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordNotMatchLabel.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return passwordNotMatchLabel
    }()
    
    
    lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Register", for: .normal)
        signUpButton.backgroundColor = .systemBlue
        signUpButton.layer.cornerRadius = 10
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.isEnabled = true
        signUpButton.alpha = 1.0
        return signUpButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerScrollView.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        createRegisterStackView()
        view.backgroundColor = .systemBackground
        username.delegate = self
        phoneNumber.delegate = self
        password.delegate = self
        rePassword.delegate = self
        signUpButton.addTarget(self, action: #selector(startOnboarding), for: .touchUpInside)
    }
        
    func createRegisterStackView() {
        
       let arrangedSubViews = [
        registerLabel,username,usernameLabel,phoneNumber,phoneNumberLabel, password,rePassword,passwordNotMatchLabel, signUpButton]

        registerStackView = UIStackView(arrangedSubviews: arrangedSubViews)
        registerStackView.translatesAutoresizingMaskIntoConstraints = false
        registerStackView.axis = .vertical
        registerStackView.distribution = .fill
        registerStackView.spacing = 15

        view.addSubview(registerScrollView)
        registerScrollView.addSubview(registerStackView)
        addConstraintsLoginStack()
    }
    
    
    func addConstraintsLoginStack() {
        NSLayoutConstraint.activate([
            registerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            registerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            registerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            registerStackView.leadingAnchor.constraint(equalTo: registerScrollView.leadingAnchor),
            registerStackView.trailingAnchor.constraint(equalTo: registerScrollView.trailingAnchor),
            registerStackView.topAnchor.constraint(equalTo: registerScrollView.topAnchor),
            registerStackView.bottomAnchor.constraint(equalTo: registerScrollView.bottomAnchor),
            registerStackView.widthAnchor.constraint(equalTo: registerScrollView.widthAnchor)
        ])
    }
    var userPassword: String?
    var userRePassword: String?
        
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == phoneNumber {
            _ = checkPhoneNumberValidation(phoneNumber: textField.text!)
        } else if textField == username {
            _ =  checkUsernameValidation(username: textField.text!)
        } else if textField == password {
            userPassword = textField.text!
        } else if textField == rePassword {
            userRePassword = textField.text!
        }
        
        if password.text!.count > Constants.minimumPasswordLength && rePassword.text!.count > Constants.minimumPasswordLength {
            _ = checkForPasswordMatch(password: password.text!, rePassword: rePassword.text!)
        }
        
    }

    func checkUsernameValidation(username: String) -> Bool {
        let usernameDetails = registerController.validateUsername(username: username)
        
        if username.count >= Constants.miniumUsernameLength {
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
        }
        
        return false
    }
    
    func checkPhoneNumberValidation(phoneNumber: String) -> Bool {
        let phoneNumberDetails = registerController.validatePhoneNumber(phoneNumber: phoneNumber)

        if phoneNumber.count >= Constants.minimumPhoneNumberLength {
            if phoneNumberDetails == .success(true) {
                validPhoneNumber()
                return true
            } else if phoneNumberDetails == .failure(.cannotBeEmpty) {
                invalidPhoneNumber(warningLabel: PhoneNumberError.cannotBeEmpty.description)
            } else if phoneNumberDetails == .failure(.invalidFormat) {
                invalidPhoneNumber(warningLabel: PhoneNumberError.invalidFormat.description)
            } else if phoneNumberDetails == .success(false) {
                invalidPhoneNumber(warningLabel: PhoneNumberError.alreadyTaken.description)
            }
        }
        
        return false
    }
    
    func checkForPasswordMatch(password: String?,rePassword: String?) -> Bool {
        if !password!.isEmpty,password == rePassword {
            passwordNotMatchLabel.isHidden = true
            return true
        }
        
        passwordNotMatchLabel.isHidden = false
        return false
    }

    @objc func startOnboarding() {
        if !checkUsernameValidation(username: username.text!) {
            invalidUserName(warningLabel: UsernameError.invalidNumberOfCharacters.description)
            return
        }
        
        if !checkPhoneNumberValidation(phoneNumber: phoneNumber.text!) {
            invalidPhoneNumber(warningLabel: PhoneNumberError.invalidFormat.description)
            return
        }
        
        if !checkForPasswordMatch(password: password.text!, rePassword: rePassword.text!) {
            return
        }
        
        registerController.executeRegistrationProcess(username: username.text!, phoneNumber: phoneNumber.text!, password: password.text!)
        navigationController?.pushViewController(OnboardingVC(), animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        if textField == phoneNumber {
            return AppUtility.textLimit(existingText: textField.text,newText: string,limit: 15)
        }
        return true
    }
    
    var contentInsetBackstore: UIEdgeInsets = .zero
    @objc private func didKeyboardAppear(notification:Notification){
        
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        
        if contentInsetBackstore != .zero {
            return
        }
        
        if contentInsetBackstore == .zero {
            contentInsetBackstore = registerScrollView.contentInset
        }
        
        registerScrollView.contentInset = UIEdgeInsets(
            top: contentInsetBackstore.top,
            left: contentInsetBackstore.left,
            bottom: keyboardFrame.height,
            right: contentInsetBackstore.right
        )
    }
    
    @objc private func didKeyboardDisappear(notification:Notification){
        registerScrollView.contentInset = contentInsetBackstore
        contentInsetBackstore = .zero
    }
}

extension RegisterVC {
    
    func enableRegisterButton() {
        signUpButton.isEnabled = true
        signUpButton.alpha = 1.0
    }
    
    func disableRegisterButton() {
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.5
    }
    
    func validUserName() {
        usernameLabel.isHidden = true
        username.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func invalidUserName(warningLabel: String) {
        username.layer.borderColor = UIColor.red.cgColor
        usernameLabel.isHidden = false
        usernameLabel.text = warningLabel
    }
        
    func validPhoneNumber() {
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberLabel.isHidden = true
    }
    
    func invalidPhoneNumber(warningLabel: String) {
        phoneNumber.layer.borderColor = UIColor.red.cgColor
        phoneNumberLabel.text = warningLabel
        phoneNumberLabel.isHidden = false
    }
}
