//
//  ChangePasswordViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 20/11/22.
//

import UIKit

class ResetPasswordVC: UIViewController,UITextFieldDelegate {
    
    private let resetPasswordControls: ResetPasswordProtocol
    init(resetPasswordControls: ResetPasswordProtocol) {
        self.resetPasswordControls = resetPasswordControls
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
    
    private lazy var currentPasswordVisibilityToggleButton: UIButton = {
        
        var configButton = UIButton.Configuration.borderless()
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let toggleButton = UIButton(configuration: configButton)
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        toggleButton.addTarget(self, action: #selector(currentPasswordVisibility), for: .touchUpInside)
        return toggleButton
    }()
    
    private lazy var currentPassword: UITextField = {
        let currentPassword = UITextField()
        currentPassword.placeholder = "Current Password"
        currentPassword.layer.cornerRadius = 10
        currentPassword.layer.borderWidth = 2
        currentPassword.layer.borderColor = UIColor.lightGray.cgColor
        currentPassword.translatesAutoresizingMaskIntoConstraints = false
        currentPassword.isSecureTextEntry = true
        currentPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: currentPassword.frame.height))
        currentPassword.leftViewMode = .always
        currentPassword.rightView = currentPasswordVisibilityToggleButton
        currentPassword.rightViewMode = .always
        return currentPassword
    }()
    
    private lazy var currentPasswordIncorrectLabel: UILabel = {
       let oldPasswordIncorrect = UILabel()
        oldPasswordIncorrect.text = "Password is incorrect"
        oldPasswordIncorrect.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordIncorrect.textColor = .red
        oldPasswordIncorrect.isHidden = true
        oldPasswordIncorrect.font = UIFont.systemFont(ofSize: 16)
       return oldPasswordIncorrect
    }()
    
    private lazy var newPasswordVisibilityToggleButton: UIButton = {
        
        var configButton = UIButton.Configuration.borderless()
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let toggleButton = UIButton(configuration: configButton)
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        toggleButton.addTarget(self, action: #selector(newPasswordVisibility), for: .touchUpInside)
        return toggleButton
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
        newPassword.rightView = newPasswordVisibilityToggleButton
        newPassword.rightViewMode = .always
        return newPassword
    }()
    
    private lazy var againNewPasswordVisibilityToggleButton: UIButton = {
        
        var configButton = UIButton.Configuration.borderless()
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let toggleButton = UIButton(configuration: configButton)
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        toggleButton.addTarget(self, action: #selector(againNewPasswordVisibility), for: .touchUpInside)
        return toggleButton
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
        againNewPassword.rightView = againNewPasswordVisibilityToggleButton
        againNewPassword.rightViewMode = .always
        return againNewPassword
    }()
    
    private lazy var newPasswordsMismatchLabel: UILabel = {
       let newPasswordsMismatch = UILabel()
        newPasswordsMismatch.text = "Passwords do not match"
        newPasswordsMismatch.translatesAutoresizingMaskIntoConstraints = false
        newPasswordsMismatch.textColor = .red
        newPasswordsMismatch.font = UIFont.systemFont(ofSize: 12)
        newPasswordsMismatch.isHidden = true
       return newPasswordsMismatch
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupDelegates()
        setConstraints()
        setupTapGestures()
        setupNotificationCenter()
    }
    
    private func setupNavigationItems() {
        title = "Reset Password"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func setupDelegates() {
        currentPassword.delegate = self
        newPassword.delegate = self
        againNewPassword.delegate = self
    }
    
    private func setupTapGestures() {
        saveButton.addTarget(self, action: #selector(saveDetails), for: .touchUpInside)
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private var isCurrentPasswordEntered: Bool = false
    private var isNewPasswordEntered: Bool = false
    private var isNewPasswordAgainEntered: Bool = false
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == currentPassword {
     
            isCurrentPasswordEntered = textField.text!.isEmpty ? false : true
            validCurrentPasswordStatus()
        }
        
        if textField == newPassword {

            if textField.text!.count < Constants.minimumPasswordLength {
                isNewPasswordEntered = false
                invalidPasswordStatus(warningLabel: PasswordActionError.lessCharacters.description)
            } else {
                isNewPasswordEntered = true
                validPasswordStatus()
            }
        }
        
        if textField == againNewPassword {
            
            if !checkForPasswordMatch(password: newPassword.text, rePassword: againNewPassword.text) {
                isNewPasswordAgainEntered = false
            } else {
                validPasswordStatus()
                isNewPasswordAgainEntered = true
            }
        }
        
        if isCurrentPasswordEntered && isNewPasswordEntered && isNewPasswordAgainEntered {
            saveButton.alpha = 1.0
            saveButton.isEnabled = true
        } else {
            saveButton.alpha = 0.5
            saveButton.isEnabled = false
        }
    }
    
    @objc private func saveDetails() {
        
        if  !resetPasswordControls.isPasswordCorrect(password: currentPassword.text!.trimmingCharacters(in: .whitespaces)) {
                  invalidCurrentPasswordStatus(warningLabel: "Current password is wrong")
            return
        }
        
        resetPasswordControls.updatePassword(password: newPassword.text!.trimmingCharacters(in: .whitespaces))
        navigationController?.popViewController(animated: true)
    }
    
    private func setConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [currentPassword,currentPasswordIncorrectLabel,newPassword,againNewPassword,newPasswordsMismatchLabel].forEach {
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
            
            currentPassword.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 20),
            currentPassword.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            currentPassword.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -10),
            currentPassword.heightAnchor.constraint(equalToConstant: 50),
            
            currentPasswordIncorrectLabel.topAnchor.constraint(equalTo: currentPassword.bottomAnchor,constant: 10),
            currentPasswordIncorrectLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            currentPasswordIncorrectLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -10),
            currentPasswordIncorrectLabel.heightAnchor.constraint(equalToConstant: 20),
            
            newPassword.topAnchor.constraint(equalTo: currentPasswordIncorrectLabel.bottomAnchor,constant: 20),
            newPassword.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            newPassword.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -10),
            newPassword.heightAnchor.constraint(equalToConstant: 50),

            againNewPassword.topAnchor.constraint(equalTo: newPassword.bottomAnchor,constant: 20),
            againNewPassword.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            againNewPassword.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -10),
            againNewPassword.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordsMismatchLabel.topAnchor.constraint(equalTo: againNewPassword.bottomAnchor,constant: 10),
            newPasswordsMismatchLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 10),
            newPasswordsMismatchLabel.trailingAnchor.constraint(equalTo:scrollContainer.trailingAnchor,constant: -10),
            newPasswordsMismatchLabel.heightAnchor.constraint(equalToConstant: 20),
            newPasswordsMismatchLabel.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        ])
    }
    
    private func invalidPasswordStatus(warningLabel: String) {
        newPasswordsMismatchLabel.text = warningLabel
        newPasswordsMismatchLabel.isHidden = false
    }
    
    private func validPasswordStatus() {
        newPasswordsMismatchLabel.isHidden = true
    }
    
    private func invalidCurrentPasswordStatus(warningLabel: String) {
        currentPasswordIncorrectLabel.text = warningLabel
        currentPasswordIncorrectLabel.isHidden = false
    }
    
    private func validCurrentPasswordStatus() {
        currentPasswordIncorrectLabel.isHidden = true
    }
    
    @objc private func currentPasswordVisibility(_ sender : UIButton) {
        if(currentPassword.isSecureTextEntry){
            currentPassword.isSecureTextEntry = false
            currentPasswordVisibilityToggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }else{
            currentPassword.isSecureTextEntry = true
            currentPasswordVisibilityToggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }
    }
    
    @objc private func newPasswordVisibility(_ sender : UIButton) {
        if(newPassword.isSecureTextEntry){
            newPassword.isSecureTextEntry = false
            newPasswordVisibilityToggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }else{
            newPassword.isSecureTextEntry = true
            newPasswordVisibilityToggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }
    }
    
    @objc private func againNewPasswordVisibility(_ sender : UIButton) {
        if(againNewPassword.isSecureTextEntry){
            againNewPassword.isSecureTextEntry = false
            againNewPasswordVisibilityToggleButton.setImage(UIImage(named: "password_invisible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }else{
            againNewPassword.isSecureTextEntry = true
            againNewPasswordVisibilityToggleButton.setImage(UIImage(named: "password_visible")?.withTintColor(UIColor(named: "appTheme")!), for: .normal)
        }
    }
    
    private func checkForPasswordMatch(password: String?,rePassword: String?) -> Bool {
        
        if password?.trimmingCharacters(in: .whitespaces) == rePassword?.trimmingCharacters(in: .whitespaces) {
            newPasswordsMismatchLabel.isHidden = true
            return true
        }
        
        newPasswordsMismatchLabel.isHidden = false
        invalidPasswordStatus(warningLabel: PasswordActionError.mismatch.description)
        return false
    }
    
    private var contentInsetBackstore: UIEdgeInsets = .zero
    @objc private func didKeyboardAppear(notification:Notification){
        
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        
        if contentInsetBackstore != .zero {
            return
        }
        
        if contentInsetBackstore == .zero {
            contentInsetBackstore = scrollView.contentInset
        }
        
        scrollView.contentInset = UIEdgeInsets(
            top: contentInsetBackstore.top,
            left: contentInsetBackstore.left,
            bottom: keyboardFrame.height,
            right: contentInsetBackstore.right
        )
    }
    
    @objc private func didKeyboardDisappear(notification:Notification){
        scrollView.contentInset = contentInsetBackstore
        contentInsetBackstore = .zero
    }
}
