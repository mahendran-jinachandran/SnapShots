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
    private lazy var registerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private lazy var registerLabel: UILabel = {
        let registerLabel = UILabel()
        registerLabel.text = "REGISTER"
        registerLabel.font =  UIFont(name: "Copperplate", size: 50)
        registerLabel.textColor = UIColor(named: "appTheme")
        registerLabel.textAlignment = .center
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.heightAnchor.constraint(equalToConstant: 180).isActive = true
        return registerLabel
    }()
    
    private lazy var username: UITextField = {
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
    
    private lazy var usernameWarningLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textColor = .red
        usernameLabel.font = usernameLabel.font.withSize(10)
        usernameLabel.isHidden = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return usernameLabel
    }()
    
    private lazy var phoneNumber: UITextField = {
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
    
    private lazy var phoneNumberWarningLabel: UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.textColor = .red
        phoneNumberLabel.font = phoneNumberLabel.font.withSize(10)
        phoneNumberLabel.isHidden = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return phoneNumberLabel
    }()
    
    private lazy var password: UITextField = {
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
    
    
    private lazy var rePassword: UITextField = {
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
    
    private lazy var passwordVisibilityToggleButton: UIButton = {
       let toggleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
       toggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
       toggleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
       return toggleButton
    }()
    
    private lazy var passwordNotMatchWarningLabel: UILabel = {
        let passwordNotMatchLabel = UILabel()
        passwordNotMatchLabel.textColor = .red
        passwordNotMatchLabel.text = "Passwords do not match"
        passwordNotMatchLabel.font = phoneNumberWarningLabel.font.withSize(10)
        passwordNotMatchLabel.isHidden = true
        passwordNotMatchLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordNotMatchLabel.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return passwordNotMatchLabel
    }()
    
    private lazy var registerButton: UIButton = {
        let registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 10
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.isEnabled = true
        registerButton.alpha = 1.0
        return registerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .systemBackground
        
        setupNotficationCenter()
        setupTapGestures()
        createRegisterStackView()
        passwordVisibilityToggleButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
    }
    
    func setupNotficationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func setupTapGestures() {
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        registerButton.addTarget(self, action: #selector(registerValidation), for: .touchUpInside)
    }
        
    func createRegisterStackView() {
        
        registerScrollView.showsVerticalScrollIndicator = false
        username.delegate = self
        phoneNumber.delegate = self
        password.delegate = self
        rePassword.delegate = self

       let arrangedSubViews = [
        registerLabel,username,usernameWarningLabel,phoneNumber,phoneNumberWarningLabel, password,rePassword,passwordNotMatchWarningLabel, registerButton]

        registerStackView = UIStackView(arrangedSubviews: arrangedSubViews)
        registerStackView.translatesAutoresizingMaskIntoConstraints = false
        registerStackView.axis = .vertical
        registerStackView.distribution = .fill
        registerStackView.spacing = 15

        addConstraintsLoginStack()
    }
    
    func addConstraintsLoginStack() {
        
        view.addSubview(registerScrollView)
        registerScrollView.addSubview(registerStackView)
        
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
        
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == phoneNumber {
            _ = checkPhoneNumberValidation(phoneNumber: textField.text!)
        } else if textField == username {
            _ =  checkUsernameValidation(username: textField.text!)
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
        
        if password == rePassword {
            passwordNotMatchWarningLabel.isHidden = true
            return true
        }
        
        passwordNotMatchWarningLabel.isHidden = false
        invalidPasswordStatus(warningLabel: PasswordActionError.mismatch.description)
        return false
    }
    
    @objc func registerValidation() {
        if !checkUsernameValidation(username: username.text!) {
            invalidUserName(warningLabel: UsernameError.invalidNumberOfCharacters.description)
            return
        }
        
        if !checkPhoneNumberValidation(phoneNumber: phoneNumber.text!) {
            invalidPhoneNumber(warningLabel: PhoneNumberError.invalidFormat.description)
            return
        }
        
        if password.text!.count < Constants.minimumPasswordLength || rePassword.text!.count < Constants.minimumPasswordLength {
            passwordNotMatchWarningLabel.isHidden = false
            passwordNotMatchWarningLabel.text = PasswordActionError.lessCharacters.description
            return
        }
        
        if !checkForPasswordMatch(password: password.text!, rePassword: rePassword.text!) {
            return
        }
        
        startOnboarding()
    }

    @objc func startOnboarding() {
        
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
    
    // MARK: KEYBOARD NOTIFICATION CENTER
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
        registerButton.isEnabled = true
        registerButton.alpha = 1.0
    }
    
    func disableRegisterButton() {
        registerButton.isEnabled = false
        registerButton.alpha = 0.5
    }
    
    func validUserName() {
        usernameWarningLabel.isHidden = true
        username.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func invalidUserName(warningLabel: String) {
        username.layer.borderColor = UIColor.red.cgColor
        usernameWarningLabel.isHidden = false
        usernameWarningLabel.text = warningLabel
    }
        
    func validPhoneNumber() {
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberWarningLabel.isHidden = true
    }
    
    func invalidPhoneNumber(warningLabel: String) {
        phoneNumber.layer.borderColor = UIColor.red.cgColor
        phoneNumberWarningLabel.text = warningLabel
        phoneNumberWarningLabel.isHidden = false
    }
    
    func invalidPasswordStatus(warningLabel: String) {
        passwordNotMatchWarningLabel.isHidden = false
        passwordNotMatchWarningLabel.text = warningLabel
    }
    
    @objc func passwordVisibility(_ sender : UIButton) {
        if(password.isSecureTextEntry){
            password.isSecureTextEntry = false
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }else{
            password.isSecureTextEntry = true
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }
    }
}
