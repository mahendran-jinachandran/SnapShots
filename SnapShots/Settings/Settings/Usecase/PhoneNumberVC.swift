//
//  PhoneNumberVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 02/12/22.
//

import UIKit

class PhoneNumberVC: UIViewController {
    
    var phoneNumber: String!
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
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
    
    private var phoneNumberImage: UIImageView = {
        let phoneNumberImage = UIImageView(frame: .zero)
        phoneNumberImage.image = UIImage(systemName: "iphone.circle")
        phoneNumberImage.clipsToBounds = true
        phoneNumberImage.contentMode = .scaleAspectFit
        phoneNumberImage.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberImage.isUserInteractionEnabled = false
        phoneNumberImage.tintColor = UIColor(named: "appTheme")
        return phoneNumberImage
    }()

    private lazy var phoneNumberTextField: UITextField = {
        let phoneNumberTextField = UITextField()
        phoneNumberTextField.text = phoneNumber
        phoneNumberTextField.layer.cornerRadius = 5
        phoneNumberTextField.layer.borderWidth = 2
        phoneNumberTextField.layer.borderColor = UIColor.gray.cgColor
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.textAlignment = .center
        return phoneNumberTextField
    }()
    
    
    lazy var phoneNumberWarningLabel: UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.textColor = .red
        phoneNumberLabel.font = phoneNumberLabel.font.withSize(10)
        phoneNumberLabel.isHidden = true
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return phoneNumberLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Phone number"
        
        setupNotificationCenter()
        setupConstraints()
        setupNavigationButtons()
    }
    
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [phoneNumberImage,phoneNumberTextField,phoneNumberWarningLabel].forEach {
            scrollContainer.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            phoneNumberImage.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 20),
            phoneNumberImage.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            phoneNumberImage.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 50),
            phoneNumberImage.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -50),
            phoneNumberImage.heightAnchor.constraint(equalToConstant: 160),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberImage.bottomAnchor,constant: 20),
            phoneNumberTextField.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            phoneNumberTextField.widthAnchor.constraint(equalToConstant: 350),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            
            phoneNumberWarningLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor,constant: 10),
            phoneNumberWarningLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            phoneNumberWarningLabel.widthAnchor.constraint(equalToConstant: 350),
            phoneNumberWarningLabel.heightAnchor.constraint(equalToConstant: 40),
            phoneNumberWarningLabel.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            
        ])
    }
    
    func setupNavigationButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(updatePhoneNumber))
    }
    
    @objc func updatePhoneNumber() {
        if !checkPhoneNumberValidation(phoneNumber: phoneNumberTextField.text!) {
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func checkPhoneNumberValidation(phoneNumber: String) -> Bool {
        let phoneNumberDetails = AccountControls().validatePhoneNumber(phoneNumber: phoneNumber)


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
        
        return false
    }
    
    func validPhoneNumber() {
        phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberWarningLabel.isHidden = true
    }
    
    func invalidPhoneNumber(warningLabel: String) {
        phoneNumberTextField.layer.borderColor = UIColor.red.cgColor
        phoneNumberWarningLabel.text = warningLabel
        phoneNumberWarningLabel.isHidden = false
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
