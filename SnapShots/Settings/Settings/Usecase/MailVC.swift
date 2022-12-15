//
//  EmailVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class MailVC: UIViewController {
    
    private var mail: String!
    private var accountControls: AccountControlsProtocol
    init(accountControls: AccountControlsProtocol,mail: String) {
        self.accountControls = accountControls
        self.mail = mail
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
        email.text = mail
        email.layer.cornerRadius = 5
        email.layer.borderWidth = 2
        email.layer.borderColor = UIColor.gray.cgColor
        email.clearButtonMode = .whileEditing
        email.setImageInTextFieldOnLeft(imageName: "mail.png")
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    private lazy var uploadLabel: UILabel = {
       let uploadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        uploadLabel.text = "Update"
        uploadLabel.textColor = UIColor(named: "appTheme")
        uploadLabel.isUserInteractionEnabled = true
        return uploadLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupConstraints()
        setupNotificationCenter()
        setupTapGestures()
    }
    
    private func setupNavigationItems() {
        title = "Mail"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadLabel)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func setupTapGestures() {
        let uploadLabelTap = UITapGestureRecognizer(target: self, action: #selector(validateMail(_:)))
        uploadLabel.addGestureRecognizer(uploadLabelTap)
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func validateMail(_ sender: UITapGestureRecognizer) {
        if let usermail = emailTextField.text,!usermail.isEmpty {
            if !accountControls.updateEmail(email: usermail) {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
        }
        
        NotificationCenter.default.post(name: Constants.profileDetailsEvent, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [mailLogo,primaryLabel,emailTextField].forEach {
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
            emailTextField.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
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
