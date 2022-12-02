//
//  OnboardingViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit
import Lottie

class OnboardingVC: UIViewController {
    
    var heightAnchor: NSLayoutConstraint?
    
    let onBoardingscrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()

    var onBoardingStackView: UIStackView!
    
    let welcomeLabel: UILabel = {
       let welcomeLabel = UILabel()
        welcomeLabel.text = "SNAPSHOTS"
        welcomeLabel.font =  UIFont(name: "Papyrus", size: 45)
        welcomeLabel.textColor = UIColor(named: "appTheme")
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
       return welcomeLabel
    }()
    
    let welcomeSubLabel: UILabel = {
       let welcomeSubLabel = UILabel()
        welcomeSubLabel.text = "A new world is rising. Discover it."
        welcomeSubLabel.font =  UIFont(name: "Papyrus", size: 20)
        welcomeSubLabel.textColor = UIColor(named: "appTheme")
        welcomeSubLabel.textAlignment = .center
        welcomeSubLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeSubLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
       return welcomeSubLabel
    }()
    
    var animationView: LottieAnimationView = {
        var animationView = LottieAnimationView()
        animationView = .init(name: "OnBoardingScreen1")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        return animationView
    }()
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderWidth = 2
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        createOnboardingStackView()
        setConstraints()
        updateScrollViewHeightConstraintActiveState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        heightAnchor?.constant = -(view.safeAreaInsets.top + view.safeAreaInsets.bottom)
    }
    
    private func updateScrollViewHeightConstraintActiveState() {
        if traitCollection.verticalSizeClass == .regular {
            heightAnchor?.isActive = true
        } else {
            heightAnchor?.isActive = false
        }
        
        view.layoutIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateScrollViewHeightConstraintActiveState()
    }
    
    func createOnboardingStackView() {
        let arrangedSubViews = [welcomeLabel,welcomeSubLabel,animationView,nextButton]

        onBoardingStackView = UIStackView(arrangedSubviews: arrangedSubViews)
        onBoardingStackView.translatesAutoresizingMaskIntoConstraints = false
        onBoardingStackView.axis = .vertical
        onBoardingStackView.distribution = .fill
        
        
        view.addSubview(onBoardingscrollView)
        onBoardingscrollView.addSubview(onBoardingStackView)
        nextButton.addTarget(self, action: #selector(goToNextOnboarding), for: .touchUpInside)
    }
    
   @objc func goToNextOnboarding() {
       animationView.stop()
       animationView.removeFromSuperview()
       
       navigationController?.pushViewController(OnboardingProfilePhotoVC(), animated: true)
    }
    
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            onBoardingscrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            onBoardingscrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            onBoardingscrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            onBoardingscrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            onBoardingStackView.topAnchor.constraint(equalTo: onBoardingscrollView.topAnchor),
            onBoardingStackView.bottomAnchor.constraint(equalTo: onBoardingscrollView.bottomAnchor),
            onBoardingStackView.leadingAnchor.constraint(equalTo: onBoardingscrollView.leadingAnchor),
            onBoardingStackView.trailingAnchor.constraint(equalTo: onBoardingscrollView.trailingAnchor),
            onBoardingStackView.widthAnchor.constraint(equalTo: onBoardingscrollView.widthAnchor),
        ])
        
        heightAnchor = onBoardingStackView.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightAnchor?.isActive = true
    }
}
