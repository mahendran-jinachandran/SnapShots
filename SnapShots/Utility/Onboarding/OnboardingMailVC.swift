//
//  MailViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingMailVC: UIViewController {
    
    private var mailLogo: UIImageView = {
        let mailLogo = UIImageView(frame: .zero)
        mailLogo.image = UIImage(systemName: "envelope")
        mailLogo.clipsToBounds = true
        mailLogo.contentMode = .scaleAspectFill
        mailLogo.translatesAutoresizingMaskIntoConstraints = false
        mailLogo.isUserInteractionEnabled = false
        mailLogo.tintColor = UIColor(named: "appTheme")
        return mailLogo
    }()
    
    private var primaryLabel: UILabel = {
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
        email.setImageInTextFieldOnLeft(imageName: "mail.png")
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    lazy var skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        skipButton.layer.cornerRadius = 10
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.isEnabled = true
        skipButton.setImage(UIImage(systemName: "chevron.right")!, for: .normal)
        skipButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        skipButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        skipButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return skipButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(validateMail))
        
        view.backgroundColor = .systemBackground
        [mailLogo,primaryLabel,emailTextField,skipButton].forEach {
            view.addSubview($0)
        }
        
        setupConstraints()
        skipButton.addTarget(self, action: #selector(navigateToNext), for: .touchUpInside)
        skipButton.tintColor = UIColor(named: "appTheme")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func validateMail() {
        
        if let usermail = emailTextField.text {
            if usermail.count == 0 || !OnboardingControls().updateEmail(email: usermail) {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
        }
        
        navigateToNext()
    }
    
    @objc func navigateToNext() {
        navigationController?.pushViewController(OnboardingGenderVC(), animated: false)
    }
    
    @objc func goToHomePage() {
        navigationController?.pushViewController(HomePageViewController(), animated: false)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mailLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 70),
            mailLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mailLogo.widthAnchor.constraint(equalToConstant: 200),
            mailLogo.heightAnchor.constraint(equalToConstant: 150),
            
            primaryLabel.topAnchor.constraint(equalTo: mailLogo.bottomAnchor,constant: 10),
            primaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryLabel.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor,constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 350),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            skipButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 20),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            skipButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
