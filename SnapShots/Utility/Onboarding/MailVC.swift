//
//  MailViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class MailVC: UIViewController {
    
    private var mailLogo: UIImageView = {
        let mailLogo = UIImageView(frame: .zero)
        mailLogo.image = UIImage(systemName: "envelope")
        mailLogo.clipsToBounds = true
        mailLogo.contentMode = .scaleAspectFill
        mailLogo.translatesAutoresizingMaskIntoConstraints = false
        mailLogo.isUserInteractionEnabled = false
        mailLogo.tintColor = UIColor(named: "mainPage")
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
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Skip", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderWidth = 2
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        [mailLogo,primaryLabel,emailTextField,nextButton].forEach {
            view.addSubview($0)
        }
        
        setupConstraints()
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    @objc func goNext() {
        
        if let usermail = emailTextField.text {
            if usermail.count == 0 {
                // MARK: CHANGE THIS LOGIC - NOTHING WILL COME HERE
            } else if !OnboardingControls().updateEmail(email: usermail) {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
        }
        
        navigationController?.pushViewController(GenderVC(), animated: false)
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
            
            emailTextField.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor,constant: 50),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 350),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
