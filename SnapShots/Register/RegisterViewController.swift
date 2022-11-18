//
//  RegisterViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit

class RegisterViewController: UIViewController,RegisterViewProtocol,UITextFieldDelegate {
    
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
        registerLabel.font =  UIFont(name: "Rightwood", size: 60)
        registerLabel.textColor = UIColor(named: "mainPage")
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
       toggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "mainPage")!), for: .normal)
       toggleButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
       toggleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        
        return toggleButton
    }()
    
    @objc func passwordVisibility(_ sender : UIButton) {
        if(password.isSecureTextEntry){
            password.isSecureTextEntry = false
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "mainPage")!), for: .normal)
        }else{
            password.isSecureTextEntry = true
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "mainPage")!), for: .normal)
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
        signUpButton.layer.borderWidth = 2
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.5
        return signUpButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        self.createRegisterStackView()
        self.view.backgroundColor = .systemBackground
        self.username.delegate = self
        self.phoneNumber.delegate = self
        self.password.delegate = self
        self.rePassword.delegate = self
        self.signUpButton.addTarget(self, action: #selector(startOnboarding), for: .touchUpInside)
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
            registerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            registerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            registerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            registerStackView.leadingAnchor.constraint(equalTo: registerScrollView.leadingAnchor),
            registerStackView.trailingAnchor.constraint(equalTo: registerScrollView.trailingAnchor),
            registerStackView.topAnchor.constraint(equalTo: registerScrollView.topAnchor),
            registerStackView.bottomAnchor.constraint(equalTo: registerScrollView.bottomAnchor),
            registerStackView.widthAnchor.constraint(equalTo: registerScrollView.widthAnchor)
        ])
    }
    
    var isUsernameEntered: Bool = false
    var isPhoneNumberEntered: Bool = false
    var isPasswordEntered: Bool = false
    var isRePasswordEntered: Bool = false
    var userPassword: String?
    var userRePassword: String?
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        

        switch textField {
            case username:
            
                let username = textField.text!
                if registerController.isValidUserName(username: username) {
                    isUsernameEntered = true
                    usernameLabel.isHidden = true
                    textField.layer.borderColor = UIColor.lightGray.cgColor
                } else {
                    isUsernameEntered = false
                    usernameLabel.isHidden = false
                    textField.layer.borderColor = UIColor.red.cgColor
                }
                
            case phoneNumber:
            
                let phoneNumber = textField.text!
                if registerController.isValidPhoneNumber(phoneNumber: phoneNumber) {
                    isPhoneNumberEntered = true
                    textField.layer.borderColor = UIColor.lightGray.cgColor
                    phoneNumberLabel.isHidden = true
                } else {
                    isPhoneNumberEntered = false
                    textField.layer.borderColor = UIColor.red.cgColor
                    phoneNumberLabel.isHidden = false
                }
            
            case password:
                userPassword = textField.text!
                isPasswordEntered = userPassword!.count > 0 ? true : false
            case rePassword:
                userRePassword = textField.text!
                isRePasswordEntered = userRePassword!.count > 0 ? true : false
                checkForPasswordMatch(password: userPassword, rePassword: userRePassword)
                
            default:
                print("NONE")
        }
        
        
        if isUsernameEntered && isPhoneNumberEntered && isPasswordEntered && isRePasswordEntered {
            signUpButton.isEnabled = true
            signUpButton.alpha = 1.0
        } else {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
        }
    }
    
    func checkForPasswordMatch(password: String?,rePassword: String?) {
        if password != rePassword {
            passwordNotMatchLabel.isHidden = false
        } else {
            passwordNotMatchLabel.isHidden = true
        }
    }
    
    @objc func startOnboarding() {
        registerController.executeRegistrationProcess(username: username.text!, phoneNumber: phoneNumber.text!, password: password.text!)
        navigationController?.pushViewController(OnboardingViewController(), animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        if textField == phoneNumber {
            return self.textLimit(existingText: textField.text,newText: string,limit: 10)
        }
        return true
    }

    private func textLimit(existingText: String?,newText: String,limit: Int) -> Bool {
        let text = existingText ?? ""
        return text.count + newText.count <= limit
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
