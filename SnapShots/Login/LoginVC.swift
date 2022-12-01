//
//  ViewController.swift
//  LoginSignUp
//
//  Created by mahendran-14703 on 27/10/22.
//

import UIKit
import Lottie

class LoginVC: UIViewController,UITextFieldDelegate,LoginViewProtocol {
    
    private var loginController: LoginControllerProtocol!
    var isPhoneNumberEntered: Bool = false
    var isPasswordEntered: Bool = false
    var loginStackView: UIStackView!
    
    public func setController(_ controller: LoginControllerProtocol) {
        loginController = controller
    }
    
    private lazy var loginScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private lazy var snapShotsLogo: UIImageView = {
        let snapShotsLogo = UIImageView()
        snapShotsLogo.image = UIImage(named: "SnapShotsLogo")
        snapShotsLogo.contentMode = .scaleAspectFit
        snapShotsLogo.translatesAutoresizingMaskIntoConstraints = false
        snapShotsLogo.heightAnchor.constraint(equalToConstant: 180).isActive = true
        return snapShotsLogo
    }()
    
    private lazy var snapShots: UILabel = {
       let snapShots = UILabel()
       snapShots.text = "SNAPSHOTS"
       snapShots.font =  UIFont(name: "Billabong", size: 45)
       snapShots.textColor = UIColor(named: "appTheme")
       snapShots.textAlignment = .center
       snapShots.translatesAutoresizingMaskIntoConstraints = false
       snapShots.heightAnchor.constraint(equalToConstant: 70).isActive = true
       return snapShots
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
    
    private lazy var phoneNumberLabel: UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.text = Constants.unregisteredPhoneNumberWarning
        phoneNumberLabel.textColor = .red
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 10)
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
    
    private lazy var passwordVisibilityToggleButton: UIButton = {
       let toggleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
       toggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
       toggleButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
       toggleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
       return toggleButton
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
       let forgotPasswordLabel = UILabel()
       forgotPasswordLabel.text = "Forgot Password?"
       forgotPasswordLabel.textAlignment = .right
       forgotPasswordLabel.font = forgotPasswordLabel.font.withSize(15)
       forgotPasswordLabel.heightAnchor.constraint(equalToConstant: 16).isActive  = true
        forgotPasswordLabel.isUserInteractionEnabled = true
       return forgotPasswordLabel
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        return loginButton
    }()
    
    private lazy var registerLink: UILabel = {
        let registerLink = UILabel()
        registerLink.text = "Don't have an account? Register."
        registerLink.translatesAutoresizingMaskIntoConstraints = false
        registerLink.font = UIFont.systemFont(ofSize: 15)
        registerLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        registerLink.textAlignment = .center
        registerLink.isUserInteractionEnabled = true
        return registerLink
    }()
    
    private lazy var condition: UILabel = {
       let snapShots = UILabel()
       snapShots.text = "Terms & conditions apply"
       snapShots.textColor = UIColor(named: "appTheme")
       snapShots.textAlignment = .center
       snapShots.font = .italicSystemFont(ofSize: 15)
       return snapShots
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
                
        loginScrollView.showsVerticalScrollIndicator = false
        navigationItem.hidesBackButton = true
        setupNotficationCenter()
        setupTapGestures()
        executeLoginProcess()
    }
    
    func setupNotficationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func setupTapGestures() {
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        let registerPage = UITapGestureRecognizer(target: self, action: #selector(startRegistrationProcess))
        registerLink.addGestureRecognizer(registerPage)
        
        let forgotPassword = UITapGestureRecognizer(target: self, action: #selector(executeForgotPasswordProcess))
        forgotPasswordLabel.addGestureRecognizer(forgotPassword)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func executeLoginProcess() {
        self.createLoginStackView()
        self.view.backgroundColor = .systemBackground
        self.phoneNumber.delegate = self
        self.password.delegate = self
        self.loginButton.addTarget(self, action: #selector(validateUserCredentials), for: .touchUpInside)
    }
        
   @objc func startRegistrationProcess(gesture: UITapGestureRecognizer) {
       let text = registerLink.text!
       let termsRange = (text as NSString).range(of: "Register")
       
       if gesture.didTapAttributedTextInLabel(label: registerLink, inRange: termsRange) {
           
           let registerView = RegisterVC()
           let registerController = RegisterControls()

           registerView.setController(registerController)
           registerController.setView(registerView)

           navigationController?.pushViewController(registerView, animated: true)
       }
       
       
   }
    
    @objc func executeForgotPasswordProcess() {
        navigationController?.pushViewController(PhoneNumberVC(), animated: true)
    }

    func createLoginStackView() {
        
       let arrangedSubViews = [
            snapShotsLogo,snapShots,phoneNumber,phoneNumberLabel,password,forgotPasswordLabel,loginButton,registerLink,condition]

        loginStackView = UIStackView(arrangedSubviews: arrangedSubViews)
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        loginStackView.axis = .vertical
        loginStackView.distribution = .fill
        loginStackView.spacing = 15
        loginStackView.setCustomSpacing(30, after: registerLink)

        view.addSubview(loginScrollView)
        loginScrollView.addSubview(loginStackView)
        
        setupLoginStackConstraints()
    }
    
    func setupLoginStackConstraints() {
        NSLayoutConstraint.activate([
            loginScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            loginScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            loginScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            loginStackView.leadingAnchor.constraint(equalTo: loginScrollView.leadingAnchor),
            loginStackView.trailingAnchor.constraint(equalTo: loginScrollView.trailingAnchor),
            loginStackView.topAnchor.constraint(equalTo: loginScrollView.topAnchor),
            loginStackView.bottomAnchor.constraint(equalTo: loginScrollView.bottomAnchor),
            loginStackView.widthAnchor.constraint(equalTo: loginScrollView.widthAnchor)

        ])
    }
    
    @objc func validateUserCredentials() {
        loginController.validateUserCredentials(phoneNumber: phoneNumber.text!, password: password.text!)
    }
    
    func goToHomePage() {
        self.view.window?.windowScene?.keyWindow?.rootViewController = HomePageViewController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: NOTIFICATION CENTER
    @objc private func didKeyboardAppear(notification:Notification){
        
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        
        if contentInsetBackstore != .zero {
            return
        }
        
        contentInsetBackstore = loginScrollView.contentInset
        loginScrollView.contentInset = UIEdgeInsets(
            top: contentInsetBackstore.top,
            left: contentInsetBackstore.left,
            bottom: keyboardFrame.height,
            right: contentInsetBackstore.right
        )
    }
    
    var contentInsetBackstore: UIEdgeInsets = .zero
    @objc private func didKeyboardDisappear(notification:Notification){
        loginScrollView.contentInset = contentInsetBackstore
        contentInsetBackstore = .zero
    }
}

extension LoginVC {
    
    @objc func passwordVisibility(_ sender : UIButton) {
        if(password.isSecureTextEntry){
            password.isSecureTextEntry = false
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }else{
            password.isSecureTextEntry = true
            passwordVisibilityToggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
       
        if textField == password {
            isPasswordEntered = textField.text!.count > 0 ? true : false
        } else if textField == phoneNumber {
            isPhoneNumberEntered = textField.text!.count > 0 ? true : false
            if isPhoneNumberEntered {
                displayValidPhoneNumber()
            } else {
                displayInvalidPhoneNumber(warningText: "Enter phone number")
            }
        }
        
        if isPasswordEntered && isPhoneNumberEntered {
            enableLoginButton()
        } else {
            disableLoginButton()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneNumber {
            if phoneNumber.text!.count > 0 {
                loginController.validatePhoneNumber(phoneNumber: phoneNumber.text!)
            } else {
                displayInvalidPhoneNumber(warningText: "Enter phone number")
            }
        }
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        
        if textField == phoneNumber {
            return AppUtility.textLimit(existingText: textField.text,newText: string,limit: 15)
        } else if textField == password {
            return AppUtility.textLimit(existingText: textField.text, newText: string, limit: 30)
        }
        
        return true
    }
    
    // MARK: DISPLAYING TO THE USER
    func displayPhoneNumberVerificationState(isVerified: Bool) {
        if isVerified {
            displayValidPhoneNumber()
        } else {
            displayInvalidPhoneNumber(warningText: Constants.unregisteredPhoneNumberWarning)
        }
    }
    
    func displayWrongCredentials() {
        
        loginController.validatePhoneNumber(phoneNumber: phoneNumber.text!)
        let invalidUserCredentials = UIAlertController(title: "Invalid credentials", message: nil, preferredStyle: .alert)
        
        let reTryOption = UIAlertAction(title: "Okay", style: .cancel)
        invalidUserCredentials.addAction(reTryOption)
        
        self.present(invalidUserCredentials, animated: true)
    }
    
    func displayValidPhoneNumber() {
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberLabel.isHidden = true
        isPhoneNumberEntered = true
    }
    
    func displayInvalidPhoneNumber(warningText: String) {
        isPhoneNumberEntered = false
        phoneNumber.layer.borderColor = UIColor.red.cgColor
        phoneNumberLabel.isHidden = false
        phoneNumberLabel.text = warningText
    }
    
    func enableLoginButton() {
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
    }
    
    func disableLoginButton() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }
}





