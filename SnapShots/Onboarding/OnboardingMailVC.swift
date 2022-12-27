//
//  MailViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingMailVC: UIViewController,UITextFieldDelegate {
    
    private var onboardingControls: OnboardingProtocol
    init(onboardingControls: OnboardingProtocol) {
        self.onboardingControls = onboardingControls
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
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var scrollContainer: UIView = {
        let scrollContainer = UIView()
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContainer.backgroundColor = .systemBackground
        return scrollContainer
    }()
    
    private lazy var mailLogo: UIImageView = {
        let mailLogo = UIImageView(frame: .zero)
        mailLogo.image = UIImage(systemName: "envelope")
        mailLogo.clipsToBounds = true
        mailLogo.contentMode = .scaleAspectFill
        mailLogo.translatesAutoresizingMaskIntoConstraints = false
        mailLogo.isUserInteractionEnabled = false
        mailLogo.tintColor = UIColor(named: "appTheme")
        return mailLogo
    }()
    
    private lazy var primaryLabel: UILabel = {
        let primaryLabel = UILabel()
        primaryLabel.text = "Your mail id can be used for various \n\t\tverification purposes"
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.textColor = .systemGray
        primaryLabel.font = UIFont.systemFont(ofSize: 16)
        primaryLabel.numberOfLines = 2
        return primaryLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.clearsOnBeginEditing = true
        email.layer.cornerRadius = 5
        email.layer.borderWidth = 2
        email.layer.borderColor = UIColor.gray.cgColor
        email.clearButtonMode = .whileEditing
        email.setImageInTextFieldOnLeft(imageName: "envelope.circle", isSystemDefined: true)
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = CustomButton(selectColour: .systemBlue, deselectColour: .systemBlue)
        nextButton.setTitle("Continue", for: .normal)
        nextButton.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderWidth = 2
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupNotficationCenter()
        setupConstraints()
        setupTapGestures()

        emailTextField.delegate = self
        nextButton.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(navigateToNext))
    }
    
    private func setupTapGestures() {
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        nextButton.addTarget(self, action: #selector(validateMail), for: .touchUpInside)
    }
    
    private func setupNotficationCenter() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func validateMail() {
        
        if let usermail = emailTextField.text {
            
            if usermail.count == 0 {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            else if !onboardingControls.updateEmail(email: usermail) {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                showToast(message: Constants.toastFailureStatus)
                return
            } 
        }
        
        navigateToNext()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailTextField.layer.borderColor = UIColor.gray.cgColor
    }
    
    @objc private func navigateToNext() {
        navigationController?.pushViewController(OnboardingGenderVC(onboardingControls: onboardingControls), animated: true)
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [mailLogo,primaryLabel,emailTextField,nextButton].forEach {
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
            
            mailLogo.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 70),
            mailLogo.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            mailLogo.widthAnchor.constraint(equalToConstant: 200),
            mailLogo.heightAnchor.constraint(equalToConstant: 150),
            
            primaryLabel.topAnchor.constraint(equalTo: mailLogo.bottomAnchor,constant: 10),
            primaryLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            primaryLabel.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor,constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 350),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
          
            nextButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 10),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor,constant: -30),
            nextButton.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.7)
        ])
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
