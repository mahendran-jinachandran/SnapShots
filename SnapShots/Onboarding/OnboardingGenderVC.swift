//
//  GenderViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit
import Firebase

class OnboardingGenderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let genders = [Constants.MALE,Constants.FEMALE]
    var pickerView = UIPickerView()
    
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
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var scrollContainer: UIView = {
        let scrollContainer = UIView()
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContainer.backgroundColor = .systemBackground
        return scrollContainer
    }()
    
    private lazy var genderImage: UIImageView = {
        let genderImage = UIImageView(frame: .zero)
        genderImage.image = UIImage(named: "genderImg")
        genderImage.tintColor = UIColor(named: "appTheme")
        genderImage.clipsToBounds = true
        genderImage.contentMode = .scaleAspectFit
        genderImage.translatesAutoresizingMaskIntoConstraints = false
        return genderImage
    }()
    
    private lazy var pickerButton: UIButton = {
        var configButton = UIButton.Configuration.borderless()
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
        
        let toggleButton = UIButton(configuration: configButton)
        toggleButton.setImage( UIImage(systemName: "arrowtriangle.down.square.fill"), for: .normal)
        return toggleButton
    }()
    
    private lazy var genderTextField: CustomTextField = {
        let gender = CustomTextField()
        gender.placeholder = "Gender"
        gender.layer.cornerRadius = 5
        gender.layer.borderWidth = 2
        gender.layer.borderColor = UIColor.gray.cgColor
        gender.translatesAutoresizingMaskIntoConstraints = false
        gender.textAlignment = .center
        gender.rightView = pickerButton
        gender.rightViewMode = .always
        return gender
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
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

        setupNavigationItems()
        setupDelegates()
        setupNotficationCenter()
        setupConstraints()
        setupTapGestures()
        
        nextButton.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(navigateToNext))
    }
    
    private func setupDelegates() {
        pickerView.delegate = self
        pickerView.dataSource = self

        genderTextField.inputView = pickerView
        genderTextField.inputAccessoryView = createToolBar()
    }
    
    private func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addGender))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @objc private func addGender() {
        genderTextField.text = genders[pickerView.selectedRow(inComponent: 0)]
        genderTextField.resignFirstResponder()
    }
    
    private func setupTapGestures() {
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        nextButton.addTarget(self, action: #selector(updateGender), for: .touchUpInside)
        pickerButton.addTarget(self, action: #selector(openKeyboard), for: .touchUpInside)
    }
    
    @objc private func openKeyboard() {
         genderTextField.becomeFirstResponder()
     }
    
    private func setupNotficationCenter() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func updateGender() {
        
        if let gender = genderTextField.text {
            if gender.count == 0 {
                genderTextField.layer.borderColor = UIColor.red.cgColor
                return
            } else if !onboardingControls.updateGender(gender: gender) {
                showToast(message: Constants.toastFailureStatus)
                return
            }
        }
        
        navigateToNext()
    }
    
    @objc private func navigateToNext() {
        navigationController?.pushViewController(OnboardingBirthdayVC(onboardingControls: onboardingControls), animated: true)
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [genderImage,genderTextField,nextButton].forEach {
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
            
            nextButton.topAnchor.constraint(equalTo: genderTextField.bottomAnchor,constant: 20),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -15),
            nextButton.heightAnchor.constraint(equalToConstant: 35),
            nextButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
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
