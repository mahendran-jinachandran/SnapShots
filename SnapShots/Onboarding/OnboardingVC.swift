//
//  OnboardingViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit
import Lottie

class OnboardingVC: UIViewController {
    
    private var heightAnchor: NSLayoutConstraint?
    private var onBoardingStackView: UIStackView!
    
    private lazy var onBoardingscrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private lazy var welcomeLabel: UILabel = {
       let welcomeLabel = UILabel()
        welcomeLabel.text = "Snapshots"
        welcomeLabel.font =  UIFont(name: "Billabong", size: 65)
        welcomeLabel.textColor = UIColor(named: "appTheme")
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
       return welcomeLabel
    }()
    
    private lazy var welcomeSubLabel: UILabel = {
       let welcomeSubLabel = UILabel()
        welcomeSubLabel.text = "A new world is rising. Discover it."
        welcomeSubLabel.font = UIFont.systemFont(ofSize: 20)
        welcomeSubLabel.textColor = UIColor(named: "appTheme")
        welcomeSubLabel.textAlignment = .center
        welcomeSubLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeSubLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
       return welcomeSubLabel
    }()
    
    private lazy var animationView: LottieAnimationView = {
        var animationView = LottieAnimationView()
        animationView = .init(name: "OnBoardingScreen1")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        return animationView
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = CustomButton(selectColour: .systemBlue, deselectColour: .systemBlue)
        nextButton.setTitle("Continue", for: .normal)
        nextButton.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderWidth = 2
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()
        createOnboardingStackView()
        setConstraints()
        updateScrollViewHeightConstraintActiveState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        heightAnchor?.constant = -(view.safeAreaInsets.top + view.safeAreaInsets.bottom)
    }
    
    private func setNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
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
    
    private func createOnboardingStackView() {
        let arrangedSubViews = [welcomeLabel,welcomeSubLabel,animationView,nextButton]

        onBoardingStackView = UIStackView(arrangedSubviews: arrangedSubViews)
        onBoardingStackView.translatesAutoresizingMaskIntoConstraints = false
        onBoardingStackView.axis = .vertical
        onBoardingStackView.distribution = .fill
        
        
        view.addSubview(onBoardingscrollView)
        onBoardingscrollView.addSubview(onBoardingStackView)
        nextButton.addTarget(self, action: #selector(goToNextOnboarding), for: .touchUpInside)
    }
    
   @objc private func goToNextOnboarding() {
       animationView.stop()
       animationView.removeFromSuperview()
       
       let onboardingControls = OnboardingControls()
       let onboardingProfilePhotoVC = OnboardingProfilePhotoVC(onboardingControls: onboardingControls)
       
       navigationController?.pushViewController(onboardingProfilePhotoVC, animated: true)
    }
    
    
    private func setConstraints() {
        
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
