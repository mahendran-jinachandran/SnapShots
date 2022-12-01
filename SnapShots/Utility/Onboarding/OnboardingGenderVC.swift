//
//  GenderViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit
import Firebase

class OnboardingGenderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let genders = ["Male","Female","Rather not say","LGBT"]
    var pickerView = UIPickerView()
    
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

        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(updateGender))
        
        view.backgroundColor = .systemBackground
        [genderImage,genderTextField,skipButton].forEach {
            view.addSubview($0)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        genderTextField.inputView = pickerView
        
        setupConstraints()
        skipButton.addTarget(self, action: #selector(navigateToNext), for: .touchUpInside)
        skipButton.tintColor = UIColor(named: "appTheme")
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
            OnboardingControls().updateGender(gender: gender)
        }
        
        navigateToNext()
    }
    
    @objc func navigateToNext() {
        navigationController?.pushViewController(OnboardingBirthdayVC(), animated: false)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            genderImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            genderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderImage.heightAnchor.constraint(equalToConstant: 160),
            
            genderTextField.topAnchor.constraint(equalTo: genderImage.bottomAnchor,constant: 20),
            genderTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderTextField.widthAnchor.constraint(equalToConstant: 350),
            genderTextField.heightAnchor.constraint(equalToConstant: 40),
            
            skipButton.topAnchor.constraint(equalTo: genderTextField.bottomAnchor,constant: 20),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            skipButton.heightAnchor.constraint(equalToConstant: 35)
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
}
