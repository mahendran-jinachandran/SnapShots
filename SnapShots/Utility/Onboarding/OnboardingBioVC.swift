//
//  BioViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingBioVC: UIViewController {
    
    private var bioLogo: UIImageView = {
        let bioLogo = UIImageView(frame: .zero)
        bioLogo.image = UIImage(systemName: "person.text.rectangle.fill")
        bioLogo.clipsToBounds = true
        bioLogo.contentMode = .scaleAspectFit
        bioLogo.translatesAutoresizingMaskIntoConstraints = false
        bioLogo.isUserInteractionEnabled = false
        bioLogo.tintColor = UIColor(named: "appTheme")
        return bioLogo
    }()
    
    private var bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.text = "Tell about yourself"
        bioLabel.textColor = UIColor(named: "appTheme")
        bioLabel.font = UIFont.boldSystemFont(ofSize: 20)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        return bioLabel
    }()
    
    private lazy var bioProfileTextView: UITextView = {
        let bioProfile = UITextView()
        bioProfile.textColor = .gray
        bioProfile.font = UIFont.systemFont(ofSize: 16)
        bioProfile.translatesAutoresizingMaskIntoConstraints = false
        bioProfile.layer.borderWidth = 1.0
        bioProfile.layer.borderColor = UIColor.gray.cgColor
        return bioProfile
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
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(finishOnboarding))
        
        
        view.backgroundColor = .systemBackground
        [bioLogo,bioLabel,bioProfileTextView,skipButton].forEach {
            view.addSubview($0)
        }
        
        setupConstraints()
        skipButton.addTarget(self, action: #selector(goToHomePage), for: .touchUpInside)
        skipButton.tintColor = UIColor(named: "appTheme")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func finishOnboarding() {
        
        if let bioProfile = bioProfileTextView.text {
             
            if bioProfile.count == 0 {
                bioProfileTextView.layer.borderColor = UIColor.red.cgColor
                return
            }
            
             OnboardingControls().updateBio(bio: bioProfile)
        }
        
        goToHomePage()
    }
    
    @objc func goToHomePage() {
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
        
            bioProfileTextView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor,constant: 20),
            bioProfileTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bioProfileTextView.widthAnchor.constraint(equalToConstant: 350),
            bioProfileTextView.heightAnchor.constraint(equalToConstant: 100),
            
            skipButton.topAnchor.constraint(equalTo: bioProfileTextView.bottomAnchor,constant: 20),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            skipButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
