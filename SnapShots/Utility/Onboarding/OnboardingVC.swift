//
//  OnboardingViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit
import Lottie

class OnboardingVC: UIViewController {

    var onBoardingStackView: UIStackView!
    
    let welcomeLabel: UILabel = {
       let welcomeLabel = UILabel()
        welcomeLabel.text = "WELCOME"
        welcomeLabel.font =  UIFont(name: "Rightwood", size: 45)
        welcomeLabel.textColor = UIColor(named: "mainPage")
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
       return welcomeLabel
    }()
    
    let welcomeSubLabel: UILabel = {
       let welcomeSubLabel = UILabel()
        welcomeSubLabel.text = "A  place  to  connect."
        welcomeSubLabel.font =  UIFont(name: "Rightwood", size: 45)
        welcomeSubLabel.textColor = UIColor(named: "mainPage")
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
        animationView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        animationView.play()
        return animationView
    }()
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(UIColor(named: "mainPage"), for: .normal)
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

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        createOnboardingStackView()
        setConstraints()

    }
    
    func createOnboardingStackView() {
        let arrangedSubViews = [welcomeLabel,welcomeSubLabel,animationView,nextButton]

        onBoardingStackView = UIStackView(arrangedSubviews: arrangedSubViews)
        onBoardingStackView.translatesAutoresizingMaskIntoConstraints = false
        onBoardingStackView.axis = .vertical
        onBoardingStackView.distribution = .fill
        
        view.addSubview(onBoardingStackView)
        nextButton.addTarget(self, action: #selector(goToNextOnboarding), for: .touchUpInside)
    }
    
   @objc func goToNextOnboarding() {
       animationView.stop()
       animationView.removeFromSuperview()
       
       navigationController?.pushViewController(ProfileCompletionVC(), animated: true)
    }
    
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            onBoardingStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            onBoardingStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            onBoardingStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            onBoardingStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8)
        ])
    }
}
