//
//  ViewController.swift
//  LoginSignUp
//
//  Created by mahendran-14703 on 27/10/22.
//

import UIKit
import Lottie


class LoginVC: UIViewController,UITextFieldDelegate {
    
    private var isPhoneNumberEntered: Bool = false
    private var isPasswordEntered: Bool = false
    private var loginStackView: UIStackView!
    private let presenter: LoginPresenter
    
    init(presenter: LoginPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
       snapShots.text = "Snapshots"
       snapShots.font =  UIFont(name: "Billabong", size: 65)
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
        phoneNumber.heightAnchor.constraint(equalToConstant: 50).isActive  = true
        phoneNumber.clearButtonMode = .whileEditing
        phoneNumber.keyboardType = .numberPad
        phoneNumber.setImageInTextFieldOnLeft(imageName: "iphone.smartbatterycase.gen2", isSystemDefined: true)
        return phoneNumber
    }()
    
    private lazy var phoneNumberWarningLabel: UILabel = {
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
        password.setImageInTextFieldOnLeft(imageName: "lock", isSystemDefined: true)
        password.isSecureTextEntry = true
        password.rightViewMode = .whileEditing
        password.rightView = passwordVisibilityToggleButton
        return password
    }()
        
    private lazy var passwordVisibilityToggleButton: UIButton = {
        var configButton = UIButton.Configuration.borderless()
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let toggleButton = UIButton(configuration: configButton )
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        toggleButton.setImage(UIImage(systemName: "eye.circle.fill"), for: .normal)
        toggleButton.tintColor = UIColor(named: "appTheme")
        
        toggleButton.addTarget(self, action: #selector(passwordVisibility), for: .touchUpInside)
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
        let loginButton = CustomButton(selectColour: .systemBlue, deselectColour: .systemBlue)
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
        registerLink.text = "Don't have an account? Register"
        let underlineAttriString = NSMutableAttributedString(string: "Don't have an account? Register")
        let range1 = ("Don't have an account? Register." as NSString).range(of: "Register")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "appTheme")!], range: range1)
        registerLink.attributedText = underlineAttriString
        registerLink.translatesAutoresizingMaskIntoConstraints = false
        registerLink.font = UIFont.systemFont(ofSize: 15)
        registerLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        registerLink.textAlignment = .center
        registerLink.isUserInteractionEnabled = true
        return registerLink
    }()
    
    private lazy var appConditions: UILabel = {
       let snapShots = UILabel()
       snapShots.text = "Terms & conditions apply"
       snapShots.textColor = UIColor(named: "appTheme")
       snapShots.textAlignment = .center
       snapShots.font = .italicSystemFont(ofSize: 15)
       return snapShots
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        
        navigationController?.isNavigationBarHidden = true
        setupNavigationItems()
        setupNotficationCenter()
        setupTapGestures()
        setupLoginPage()
    }
    
    private func bindToViewModel() {
        
        presenter.$errorUser.bind(fire: true) { [weak self] error in
            
            guard let self else { return }
                switch error {
                    case let .doesNotExist(reason):
                        self.displayInvalidPhoneNumber(warningText: reason)
                    case .notAValidUser(_):
                        self.displayWrongCredentials()
                    default:
                        print("Handle remaining")
            }
        }
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupNotficationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func setupTapGestures() {

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
        
        registerLink.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(executeRegistrationProcess))
        )
        
        forgotPasswordLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(executeForgotPasswordProcess))
        )
        
        loginButton.addTarget(self, action: #selector(validateUserCredentials(_:)), for: .touchUpInside)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLoginPage() {
        loginScrollView.showsVerticalScrollIndicator = false
        phoneNumber.delegate = self
        password.delegate = self
        setupLoginStackView()
    }

    private func setupLoginStackView() {
        
       let arrangedSubViews = [
            snapShotsLogo,snapShots,phoneNumber,phoneNumberWarningLabel,password,forgotPasswordLabel,loginButton,registerLink,appConditions]

        loginStackView = UIStackView(arrangedSubviews: arrangedSubViews)
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        loginStackView.axis = .vertical
        loginStackView.distribution = .fill
        loginStackView.spacing = 15
        loginStackView.setCustomSpacing(30, after: registerLink)
        
        setupLoginStackConstraints()
    }
    
    private func setupLoginStackConstraints() {
        
        view.addSubview(loginScrollView)
        loginScrollView.addSubview(loginStackView)
        
        NSLayoutConstraint.activate([
            loginScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            loginScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            loginScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            loginScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            loginStackView.leadingAnchor.constraint(equalTo: loginScrollView.leadingAnchor),
            loginStackView.trailingAnchor.constraint(equalTo: loginScrollView.trailingAnchor),
            loginStackView.topAnchor.constraint(equalTo: loginScrollView.topAnchor),
            loginStackView.bottomAnchor.constraint(equalTo: loginScrollView.bottomAnchor),
            loginStackView.widthAnchor.constraint(equalTo: loginScrollView.widthAnchor)
        ])
    }
    
    @objc private func validateUserCredentials(_ sender: UIButton) {
        presenter.validateLogin(phoneNumber: phoneNumber.text!, password: password.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

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
    
    private var contentInsetBackstore: UIEdgeInsets = .zero
    @objc private func didKeyboardDisappear(notification:Notification){
        loginScrollView.contentInset = contentInsetBackstore
        contentInsetBackstore = .zero
    }
}

extension LoginVC {
    @objc private func passwordVisibility(_ sender : UIButton) {
        
        let imageName = password.isSecureTextEntry ? "eye.slash.circle.fill" : "eye.circle.fill"
        passwordVisibilityToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        password.isSecureTextEntry = password.isSecureTextEntry ? false : true
    }

    internal func textFieldDidChangeSelection(_ textField: UITextField) {
       
        if textField == password {
            isPasswordEntered = textField.text!.count > 0 ? true : false
        } else if textField == phoneNumber {
        
            isPhoneNumberEntered = textField.text!.count > 0 ? true : false
            if isPhoneNumberEntered {
                displayValidPhoneNumber()
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
            if phoneNumber.text!.count >= 8 {
                presenter.validateLogin(phoneNumber: phoneNumber.text!, password: "")
            } else {
                displayInvalidPhoneNumber(warningText: "Enter valid phone number of \(Constants.phoneNumberLength)")
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
    
    @objc private func executeRegistrationProcess(gesture: UITapGestureRecognizer) {
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
     
    @objc private func executeForgotPasswordProcess() {
         navigationController?.pushViewController(OTPPhoneNumberVC(), animated: true)
     }
    
    func displayPhoneNumberVerificationState(isVerified: Bool) {
        if isVerified {
            displayValidPhoneNumber()
        } else {
            displayInvalidPhoneNumber(warningText: Constants.unregisteredPhoneNumberWarning)
        }
    }
}

extension LoginVC {
    private func displayValidPhoneNumber() {
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberWarningLabel.isHidden = true
        isPhoneNumberEntered = true
    }
    
    private func displayInvalidPhoneNumber(warningText: String) {
        isPhoneNumberEntered = false
        phoneNumber.layer.borderColor = UIColor.red.cgColor
        phoneNumberWarningLabel.isHidden = false
        phoneNumberWarningLabel.text = warningText
    }
    
    private func enableLoginButton() {
        loginButton.isEnabled = true
        loginButton.alpha = 1.0
    }
    
    private func disableLoginButton() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }
    
    internal func displayWrongCredentials() {
        let invalidUserCredentials = UIAlertController(title: "Invalid credentials", message: nil, preferredStyle: .alert)

        let reTryOption = UIAlertAction(title: "Okay", style: .cancel)
        invalidUserCredentials.addAction(reTryOption)
        
        self.present(invalidUserCredentials, animated: true)
    }
}
