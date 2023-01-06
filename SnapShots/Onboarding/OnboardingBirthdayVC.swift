//
//  DOBViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingBirthdayVC: UIViewController {
    
    private var onboardingControls: OnboardingProtocol
    private let datePicker = UIDatePicker()
    
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
    
    private lazy var birthdayLogo: UIImageView = {
        let birthdayLogo = UIImageView(frame: .zero)
        birthdayLogo.image = UIImage(systemName: "birthday.cake")
        birthdayLogo.clipsToBounds = true
        birthdayLogo.contentMode = .scaleAspectFit
        birthdayLogo.translatesAutoresizingMaskIntoConstraints = false
        birthdayLogo.isUserInteractionEnabled = false
        birthdayLogo.tintColor = UIColor(named: "appTheme")
        return birthdayLogo
    }()
    
    private lazy var pickerButton: UIButton = {
        var configButton = UIButton.Configuration.borderless()
        configButton.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let toggleButton = UIButton(configuration: configButton)
        toggleButton.setImage( UIImage(systemName: "chevron.down"), for: .normal)
        return toggleButton
    }()

    private lazy var dateOfBirth: CustomTextField = {
        let dateOfBirth = CustomTextField()
        dateOfBirth.placeholder = "Birthday"
        dateOfBirth.layer.cornerRadius = 5
        dateOfBirth.layer.borderWidth = 2
        dateOfBirth.layer.borderColor = UIColor.gray.cgColor
        dateOfBirth.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirth.textAlignment = .center
        dateOfBirth.rightView = pickerButton
        dateOfBirth.rightViewMode = .always
        return dateOfBirth
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = CustomButton(selectColour: .systemBlue, deselectColour: .systemBlue)
        nextButton.setTitle("Continue", for: .normal)
        nextButton.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderWidth = 2
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupNotficationCenter()
        setConstraints()
        setupDatePicker()
        setupTapGestures()
        
        nextButton.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(navigateToNext))
    }
    
    private func setupTapGestures() {

        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
        
        nextButton.addTarget(self, action: #selector(updateBirthday), for: .touchUpInside)
        pickerButton.addTarget(self, action: #selector(openBirthdayPickerView), for: .touchUpInside)
        dateOfBirth.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openBirthdayPickerView)))
    }
    
    var isOpened: Bool = false
    @objc private func openBirthdayPickerView() {
        
        isOpened = !isOpened
        
        if isOpened {
            dateOfBirth.becomeFirstResponder()
            pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: false)
        } else {
            dateOfBirth.resignFirstResponder()
            pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
        }
     }
    
    private func setupNotficationCenter() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
    }
    
    @objc private func updateBirthday() {
        
        if let birthday = dateOfBirth.text {
            if birthday.count == 0 {
                dateOfBirth.layer.borderColor = UIColor.red.cgColor
                return
            } else if !onboardingControls.updateBirthday(birthday: birthday) {
               showToast(message: Constants.toastFailureStatus)
                return
            }
        }
        
       navigateToNext()
    }
    @objc private func navigateToNext() {
        navigationController?.pushViewController(OnboardingBioVC(onboardingControls: onboardingControls), animated: true)
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        dateOfBirth.inputView = datePicker
        dateOfBirth.inputAccessoryView = createToolBar()
    }
    
    private func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addBirthday))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @objc private func addBirthday() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateOfBirth.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
    }
    
    private func setConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [birthdayLogo,dateOfBirth,nextButton].forEach {
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
            
            birthdayLogo.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 20),
            birthdayLogo.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            birthdayLogo.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 50),
            birthdayLogo.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -50),
            birthdayLogo.heightAnchor.constraint(equalToConstant: 160),
            
            dateOfBirth.topAnchor.constraint(equalTo: birthdayLogo.bottomAnchor,constant: 20),
            dateOfBirth.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            dateOfBirth.widthAnchor.constraint(equalToConstant: 350),
            dateOfBirth.heightAnchor.constraint(equalToConstant: 40),

            nextButton.topAnchor.constraint(equalTo: dateOfBirth.bottomAnchor,constant: 10),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor,constant: -30),
            nextButton.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor, multiplier: 0.7)
        ])
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


class MyTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender)
        return false
    }
}
