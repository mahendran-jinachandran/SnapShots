//
//  PhoneNumberVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class OTPPhoneNumberVC: UIViewController,UITextFieldDelegate {
    
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

    private lazy var phoneNumberLabel: UILabel = {
        var phoneNumber = UILabel()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.text = "Enter your registered \n\tphone number"
        phoneNumber.textColor = UIColor(named: "appTheme")
        phoneNumber.font = UIFont.boldSystemFont(ofSize: 20)
        phoneNumber.numberOfLines = 2
        return phoneNumber
    }()
    
    private lazy var phoneNumber: UITextField = {
        let phoneNumber = UITextField()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.placeholder = "Phone number"
        phoneNumber.layer.cornerRadius = 10
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.clearButtonMode = .whileEditing
        phoneNumber.keyboardType = .numberPad
        phoneNumber.setImageInTextFieldOnLeft(imageName: "smartPhone.png")
        return phoneNumber
    }()
    
    private lazy var sendOTPButton: UIButton = {
       var sendOTPButton = CustomButton(selectColour: UIColor(named: "appTheme")!, deselectColour: UIColor(named: "appTheme")!)
        sendOTPButton.translatesAutoresizingMaskIntoConstraints = false
        sendOTPButton.setTitle("Send OTP", for: .normal)
        sendOTPButton.setTitleColor(.systemBackground, for: .normal)
        sendOTPButton.backgroundColor = UIColor(named: "appTheme")
        sendOTPButton.layer.cornerRadius = 5
        return sendOTPButton
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
    
    private lazy var blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupConstraints()
        setupNotificationCenter()
        setupTapGestures()
        phoneNumber.delegate = self

    }
    
    private func setupTapGestures() {
        sendOTPButton.addTarget(self, action: #selector(validatePhoneNumber), for: .touchUpInside)
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func validatePhoneNumber() {
        if AppUtility.validatePhoneNumber(phoneNumber: phoneNumber.text!) == .success(false){
            phoneNumberWarningLabel.isHidden = true
            phoneNumber.resignFirstResponder()
            sendOTP()
        } else {
            phoneNumberWarningLabel.isHidden = false
        }
    }
    
    @objc func sendOTP() {

        if let phoneNumber = phoneNumber.text,!phoneNumber.isEmpty {
            AuthManager.shared.startAuth(phoneNumber: "+91\(phoneNumber)") { [weak self] success in

                if !success {
                    self!.unblurTheScreen()
                    self!.showToast(message: Constants.toastFailureStatus)
                    return
                }

                DispatchQueue.main.async {
                    self!.unblurTheScreen()
                    self?.navigationController?.pushViewController(OTPScreenVC(phoneNumber: phoneNumber), animated: true)
                }
            }

            blurTheScreen()
        }
    }

    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,newText: string,limit: 15)
    }

    private func textLimit(existingText: String?,newText: String,limit: Int) -> Bool {
        let text = existingText ?? ""
        return text.count + newText.count <= limit
    }
    
    func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [phoneNumberLabel,phoneNumber,phoneNumberWarningLabel,sendOTPButton].forEach {
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
            
            phoneNumberLabel.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 20),
            phoneNumberLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            phoneNumberLabel.heightAnchor.constraint(equalToConstant: 60),
            phoneNumberLabel.widthAnchor.constraint(equalToConstant: 200),
            
            phoneNumber.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor,constant: 20),
            phoneNumber.heightAnchor.constraint(equalToConstant: 50),
            phoneNumber.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 20),
            phoneNumber.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -20),
            
            phoneNumberWarningLabel.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor,constant: 20),
            phoneNumberWarningLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            
            sendOTPButton.topAnchor.constraint(equalTo: phoneNumberWarningLabel.bottomAnchor,constant: 20),
            
            sendOTPButton.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            sendOTPButton.heightAnchor.constraint(equalToConstant: 40),
            sendOTPButton.widthAnchor.constraint(equalToConstant: 100),
            sendOTPButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        ])
    }
    
    private func blurTheScreen() {
        self.startLoadingActivityIndicator()
        view.addSubview(blurEffect)
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    private func unblurTheScreen() {
        self.stopAnimating()
        self.blurEffect.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    
    var activityIndicatorView: UIActivityIndicatorView!
    private func startLoadingActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        self.blurEffect.contentView.addSubview(activityIndicatorView)
        
    
        activityIndicatorView.frame = CGRect(
            x: view.frame.size.width / 2 ,
            y: view.frame.size.height / 2 ,
            width: 50,
            height: 50)
        
        activityIndicatorView.startAnimating()
    }
    
    private func stopAnimating() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
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
