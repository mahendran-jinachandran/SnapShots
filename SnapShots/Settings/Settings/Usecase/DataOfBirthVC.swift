//
//  DataOfBirthVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class DataOfBirthVC: UIViewController {
    
    private var dateOfBirth: String!
    private let datePicker = UIDatePicker()
    
    private var accountControls: AccountControlsProtocol
    init(accountControls: AccountControlsProtocol,dateOfBirth: String) {
        self.accountControls = accountControls
        self.dateOfBirth = dateOfBirth
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

    private lazy var dateOfBirthTextField: CustomTextField = {
        let dateOfBirthTextField = CustomTextField()
        dateOfBirthTextField.text = dateOfBirth
        dateOfBirthTextField.layer.cornerRadius = 5
        dateOfBirthTextField.layer.borderWidth = 2
        dateOfBirthTextField.layer.borderColor = UIColor.gray.cgColor
        dateOfBirthTextField.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthTextField.textAlignment = .center
        dateOfBirthTextField.rightView = pickerButton
        dateOfBirthTextField.rightViewMode = .always
        
        return dateOfBirthTextField
    }()
    
    private lazy var uploadLabel: UILabel = {
       let uploadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        uploadLabel.text = "Update"
        uploadLabel.textColor = UIColor(named: "appTheme")
        uploadLabel.isUserInteractionEnabled = true
        return uploadLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setConstraints()
        setupDatePicker()
        setupTapGestures()
        setupNotificationCenter()
        
    }
    
    private func setupNavigationItems() {
        title = "Date of birth"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadLabel)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func setupTapGestures() {
        
        uploadLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(updateBirthday(_:)))
        )
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
        
        pickerButton.addTarget(self, action: #selector(openBirthdayPickerView), for: .touchUpInside)
        dateOfBirthTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openBirthdayPickerView)))
    }
    
    var isOpened: Bool = false
    @objc private func openBirthdayPickerView() {
        
        isOpened = !isOpened
        
        if isOpened {
            dateOfBirthTextField.becomeFirstResponder()
            pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: false)
        } else {
            dateOfBirthTextField.resignFirstResponder()
            pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
        }
     }
    
    @objc private func updateBirthday(_ sender: UITapGestureRecognizer) {
        
        if let birthday = dateOfBirthTextField.text,!birthday.isEmpty {
            if !accountControls.updateBirthday(birthday: birthday) {
                dateOfBirthTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
   //     NotificationCenter.default.post(name: Constants.profileDetailsEvent, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.inputAccessoryView = createToolBar()
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
        
        dateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
    }
    
    private func setConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [birthdayLogo,dateOfBirthTextField].forEach {
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
            
            dateOfBirthTextField.topAnchor.constraint(equalTo: birthdayLogo.bottomAnchor,constant: 20),
            dateOfBirthTextField.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            dateOfBirthTextField.widthAnchor.constraint(equalToConstant: 350),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: 40),
            dateOfBirthTextField.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
            
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
