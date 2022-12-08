//
//  GenderViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit
import Firebase

class OnboardingGenderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let genders = ["Male","Female"]
    var pickerView = UIPickerView()
    
    private var onboardingControls: OnboardingProtocol
    init(onboardingControls: OnboardingProtocol) {
        self.onboardingControls = onboardingControls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView: UIScrollView = {
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
    
    private var genderImage: UIImageView = {
        let genderImage = UIImageView(frame: .zero)
        genderImage.image = UIImage(named: "genderImg")
        genderImage.tintColor = UIColor(named: "appTheme")
        genderImage.clipsToBounds = true
        genderImage.contentMode = .scaleAspectFit
        genderImage.translatesAutoresizingMaskIntoConstraints = false
        return genderImage
    }()
    
    private lazy var genderTextField: UITextField = {
        let gender = UITextField()
        gender.placeholder = "Gender"
        gender.layer.cornerRadius = 5
        gender.layer.borderWidth = 2
        gender.layer.borderColor = UIColor.gray.cgColor
        gender.translatesAutoresizingMaskIntoConstraints = false
        gender.textAlignment = .center
        return gender
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

        view.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(updateGender))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        genderTextField.inputView = pickerView
        
        setupNotficationCenter()
        setupConstraints()
        
        skipButton.addTarget(self, action: #selector(navigateToNext), for: .touchUpInside)
        skipButton.tintColor = UIColor(named: "appTheme")
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    
    func setupNotficationCenter() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func updateGender() {
        
        if let gender = genderTextField.text {
            if gender.count == 0 {
                genderTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            
            if onboardingControls.updateGender(gender: gender) {
                showToast(message: "Gender Updated")
            } else {
                showToast(message: Constants.toastFailureStatus)
            }
        }
        
        navigateToNext()
    }
    
    @objc func navigateToNext() {
        navigationController?.pushViewController(OnboardingBirthdayVC(onboardingControls: onboardingControls), animated: false)
    }
    
    func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [genderImage,genderTextField,skipButton].forEach {
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
            
            genderImage.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 20),
            genderImage.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            genderImage.heightAnchor.constraint(equalToConstant: 160),
            
            genderTextField.topAnchor.constraint(equalTo: genderImage.bottomAnchor,constant: 20),
            genderTextField.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            genderTextField.widthAnchor.constraint(equalToConstant: 350),
            genderTextField.heightAnchor.constraint(equalToConstant: 40),
            
            skipButton.topAnchor.constraint(equalTo: genderTextField.bottomAnchor,constant: 20),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -15),
            skipButton.heightAnchor.constraint(equalToConstant: 35),
            skipButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        genderTextField.resignFirstResponder()
    }
    
    // MARK: KEYBOARD NOTIFICATION CENTER
    var contentInsetBackstore: UIEdgeInsets = .zero
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
