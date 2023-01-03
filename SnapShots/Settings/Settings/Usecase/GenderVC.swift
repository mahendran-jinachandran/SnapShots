//
//  GenderVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class GenderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    private var pickerView = UIPickerView()
    
    private var gender: String!
    private var accountControls: AccountControlsProtocol
    
    init(accountControls: AccountControlsProtocol,gender: String) {
        self.accountControls = accountControls
        self.gender = gender
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
    
    private var genderImage: UIImageView = {
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
        toggleButton.setImage( UIImage(systemName: "chevron.down"), for: .normal)
        return toggleButton
    }()
    
    private lazy var genderTextField: CustomTextField = {
        let genderTextField = CustomTextField()
        genderTextField.text = gender
        genderTextField.layer.cornerRadius = 5
        genderTextField.layer.borderWidth = 2
        genderTextField.layer.borderColor = UIColor.gray.cgColor
        genderTextField.translatesAutoresizingMaskIntoConstraints = false
        genderTextField.textAlignment = .center
        genderTextField.rightView = pickerButton
        genderTextField.rightViewMode = .always
        return genderTextField
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
        setupDelegates()
        setupConstraints()
        setupNotificationCenter()
        setupTapGestures()
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        title = "Gender"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadLabel)
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
        genderTextField.text = Constants.genders[pickerView.selectedRow(inComponent: 0)]
        genderTextField.resignFirstResponder()
        pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
    }
    
    private func setupTapGestures() {
        let uploadLabelTap = UITapGestureRecognizer(target: self, action: #selector(updateGender(_:)))
        uploadLabel.addGestureRecognizer(uploadLabelTap)
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        pickerButton.addTarget(self, action: #selector(openGenderPickerView), for: .touchUpInside)
    }
    
    
   @objc private func openGenderPickerView() {
        genderTextField.becomeFirstResponder()
        pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: false)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        pickerButton.updateExpandAndCollapseStateAnimation(isExpanded: true)
    }
    
    @objc private func updateGender(_ sender: UITapGestureRecognizer) {
        
        if let gender = genderTextField.text, !gender.isEmpty {
            if !accountControls.updateGender(gender: gender) {
                genderTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
        }
        
        NotificationCenter.default.post(name: Constants.profileDetailsEvent, object: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [genderImage,genderTextField].forEach {
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
            genderTextField.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  Constants.genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  Constants.genders[row]
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
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
