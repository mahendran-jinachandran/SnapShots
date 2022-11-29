//
//  BioViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class BioVC: UIViewController {
    
    private var bioLogo: UIImageView = {
        let bioLogo = UIImageView(frame: .zero)
        bioLogo.image = UIImage(systemName: "person.text.rectangle.fill")
        bioLogo.clipsToBounds = true
        bioLogo.contentMode = .scaleAspectFit
        bioLogo.translatesAutoresizingMaskIntoConstraints = false
        bioLogo.isUserInteractionEnabled = false
        bioLogo.tintColor = UIColor(named: "mainPage")
        return bioLogo
    }()
    
    private var bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.text = "Tell about yourself"
        bioLabel.textColor = UIColor(named: "mainPage")
        bioLabel.font = UIFont.boldSystemFont(ofSize: 20)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        return bioLabel
    }()
    
    private lazy var bioProfile: UITextView = {
        let bioProfile = UITextView()
        bioProfile.textColor = .gray
        bioProfile.font = UIFont.systemFont(ofSize: 16)
        bioProfile.translatesAutoresizingMaskIntoConstraints = false
        bioProfile.layer.borderWidth = 1.0
        bioProfile.layer.borderColor = UIColor.gray.cgColor
        return bioProfile
    }()
    
    lazy var finishButton: UIButton = {
        let finishButton = UIButton()
        finishButton.setTitle("Finish", for: .normal)
        finishButton.setTitleColor(.black, for: .normal)
        finishButton.backgroundColor = .systemBlue
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderWidth = 2
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.isEnabled = true
        finishButton.alpha = 1.0
        return finishButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .systemBackground
        [bioLogo,bioLabel,bioProfile,finishButton].forEach {
            view.addSubview($0)
        }
        
        setupConstraints()
        finishButton.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
    }
    
    @objc func finishOnboarding() {
        
        if let bioProfile = bioProfile.text {
             OnboardingControls().updateBio(bio: bioProfile)
        }
        
        goToHomePage()
    }
    
    func goToHomePage() {
        self.view.window?.windowScene?.keyWindow?.rootViewController = HomePageViewController()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            bioLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            bioLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            bioLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50),
            bioLogo.heightAnchor.constraint(equalToConstant: 160),
            
            bioLabel.topAnchor.constraint(equalTo: bioLogo.bottomAnchor,constant: 20),
            bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 30),
        
            bioProfile.topAnchor.constraint(equalTo: bioLabel.bottomAnchor,constant: 20),
            bioProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioProfile.widthAnchor.constraint(equalToConstant: 350),
            bioProfile.heightAnchor.constraint(equalToConstant: 100),
            
            finishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            finishButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
