//
//  GenderVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class GenderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let genders = ["Male","Female","Rather not say","LGBT"]
    var pickerView = UIPickerView()
    
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
    
    private lazy var uploadLabel: UILabel = {
       let uploadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        uploadLabel.text = "Upload"
        uploadLabel.textColor = .systemBlue
        uploadLabel.isUserInteractionEnabled = true
        return uploadLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)

        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadLabel)
        
        let uploadLabelTap = UITapGestureRecognizer(target: self, action: #selector(updateGender(_:)))
        uploadLabel.addGestureRecognizer(uploadLabelTap)
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [genderImage,genderTextField].forEach {
            scrollContainer.addSubview($0)
        }
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        genderTextField.inputView = pickerView
        
        setupConstraints()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func updateGender(_ sender: UITapGestureRecognizer) {
        
        if let gender = genderTextField.text, !gender.isEmpty {
            if !AccountControls().updateGender(gender: gender) {
                genderTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func setupConstraints() {
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
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        genderTextField.resignFirstResponder()
    }
    
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
