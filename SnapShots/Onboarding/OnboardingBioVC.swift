//
//  BioViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingBioVC: UIViewController,UITextViewDelegate {
    
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
        scrollView.showsVerticalScrollIndicator = false
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
    
    private lazy var bioLogo: UIImageView = {
        let bioLogo = UIImageView(frame: .zero)
        bioLogo.image = UIImage(systemName: "person.text.rectangle.fill")
        bioLogo.clipsToBounds = true
        bioLogo.contentMode = .scaleAspectFit
        bioLogo.translatesAutoresizingMaskIntoConstraints = false
        bioLogo.isUserInteractionEnabled = false
        bioLogo.tintColor = UIColor(named: "appTheme")
        return bioLogo
    }()
    
    private lazy var bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.text = "Tell about yourself"
        bioLabel.textColor = UIColor(named: "appTheme")
        bioLabel.font = UIFont.boldSystemFont(ofSize: 20)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        return bioLabel
    }()
    
    private lazy var profileBioTextView: UITextView = {
        let bioProfile = UITextView()
        bioProfile.textColor = UIColor(named: "appTheme")
        bioProfile.font = UIFont.systemFont(ofSize: 16)
        bioProfile.translatesAutoresizingMaskIntoConstraints = false
        bioProfile.layer.borderWidth = 1.0
        bioProfile.layer.borderColor = UIColor(named: "appTheme")?.cgColor
        return bioProfile
    }()
    
    private lazy var maximumBioLength: UILabel = {
        let maximumBioLength = UILabel()
        maximumBioLength.text = "Maximum character limit reached"
        maximumBioLength.translatesAutoresizingMaskIntoConstraints = false
        maximumBioLength.textColor = .red
        maximumBioLength.font = UIFont.systemFont(ofSize: 10)
        maximumBioLength.isHidden = true
        maximumBioLength.heightAnchor.constraint(equalToConstant: 12).isActive  = true
        return maximumBioLength
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Finish", for: .normal)
        nextButton.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isEnabled = true
        nextButton.setImage(UIImage(systemName: "chevron.right")!, for: .normal)
        nextButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        nextButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        nextButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileBioTextView.delegate = self
        setupNavigationItems()
        setupNotficationCenter()
        setupConstraints()
        setupTapGestures()
        
        profileBioTextView.delegate = self
        nextButton.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipProcess))
    }
    
    private func setupTapGestures() {
        nextButton.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    
    private func setupNotficationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func finishOnboarding() {
        let bioProfile = profileBioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
        if bioProfile.count == 0 {
            profileBioTextView.layer.borderColor = UIColor.red.cgColor
            return
        } else if !onboardingControls.updateBio(bio: bioProfile) {
            showToast(message: Constants.toastFailureStatus)
            return
        }
        
        goToHomePage()
    }
    
    @objc private func goToHomePage() {
        self.view.window?.windowScene?.keyWindow?.rootViewController = HomePageViewController()
    }
    
    @objc private func skipProcess() {
        _ = onboardingControls.updateBio(bio: Constants.noUserBioDefault)
        self.view.window?.windowScene?.keyWindow?.rootViewController = HomePageViewController()
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [bioLogo,bioLabel,profileBioTextView,maximumBioLength,nextButton].forEach {
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
            
            bioLogo.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 20),
            bioLogo.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            bioLogo.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 50),
            bioLogo.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -50),
            bioLogo.heightAnchor.constraint(equalToConstant: 160),
            
            bioLabel.topAnchor.constraint(equalTo: bioLogo.bottomAnchor,constant: 20),
            bioLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 30),
        
            profileBioTextView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor,constant: 20),
            profileBioTextView.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            profileBioTextView.widthAnchor.constraint(equalToConstant: 350),
            profileBioTextView.heightAnchor.constraint(equalToConstant: 100),
            
            maximumBioLength.topAnchor.constraint(equalTo: profileBioTextView.bottomAnchor,constant: 8),
            maximumBioLength.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.topAnchor.constraint(equalTo: profileBioTextView.bottomAnchor,constant: 20),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -15),
            nextButton.heightAnchor.constraint(equalToConstant: 35),
            nextButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        ])
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count < 70 && newText.count > 0 {
            profileBioTextView.layer.borderColor = UIColor(named: "appTheme")?.cgColor
            maximumBioLength.isHidden = true
            return true
        } else {
            maximumBioLength.isHidden = false
            return false
        }
    }
    
    @objc private func handleKeyboard(_ notification: Notification) {
        
        var scrollViewMovingOffsetY: CGFloat = 0
        
        if notification.name == UIResponder.keyboardDidHideNotification {
            scrollView.contentInset = .zero
        }
        
        if notification.name != UIResponder.keyboardDidHideNotification, let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            let scrollViewMaxY = self.view.convert(
                scrollView.frame,
                to: nil
            ).maxY
            
            scrollViewMovingOffsetY = -(scrollViewMaxY - keyboardFrame.minY) + scrollViewMovingOffsetY + scrollView.contentInset.bottom
            
            if let keyWindow = view.window {
                scrollViewMovingOffsetY -= (UIScreen.main.bounds.height - keyWindow.frame.height) / 2
            }
        }
        
        let keyboardAwareInset = UIEdgeInsets(
            top: scrollView.contentInset.top,
            left: scrollView.contentInset.left,
            bottom: scrollView.contentInset.bottom + abs(scrollViewMovingOffsetY),
            right: scrollView.contentInset.right
        )
        scrollView.contentInset = keyboardAwareInset
        
        var firstResponderView: UIView? = nil
        if profileBioTextView.isFirstResponder {
            firstResponderView = profileBioTextView
        } else if profileBioTextView.isFirstResponder {
            firstResponderView = profileBioTextView
        }

        UIView.animate(withDuration: notification.name == UIResponder.keyboardDidShowNotification ? 0 : 0.25) {[weak self] in
            self?.view.layoutIfNeeded()
        } completion: {[weak self] finished in
            guard let self = self else { return }

            if let focusedView = firstResponderView {
                if self.scrollView.isDecelerating { return }
                    self.scrollView.scrollRectToVisible(focusedView.superview!.frame, animated: true)

            }
        }
    }
}
