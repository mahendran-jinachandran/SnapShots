//
//  GenderViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class GenderVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let genders = ["Male","Female","Rather not say","LGBT"]
    var pickerView = UIPickerView()
    
    private var genderImage: UIImageView = {
        let genderImage = UIImageView(frame: .zero)
        genderImage.image = UIImage(named: "genderImg")
      //  genderImage.tintColor = UIColor(named: "mainPage")
        genderImage.clipsToBounds = true
        genderImage.contentMode = .scaleAspectFit
        genderImage.translatesAutoresizingMaskIntoConstraints = false
        return genderImage
    }()
    
    private lazy var gender: UITextField = {
        let gender = UITextField()
        gender.placeholder = "Gender"
        gender.layer.cornerRadius = 5
        gender.layer.borderWidth = 2
        gender.layer.borderColor = UIColor.gray.cgColor
        gender.translatesAutoresizingMaskIntoConstraints = false
        gender.textAlignment = .center
        return gender
    }()
    
    lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Skip", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 10
        nextButton.layer.borderWidth = 2
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.isEnabled = true
        nextButton.alpha = 1.0
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .systemBackground
        [genderImage,gender,nextButton].forEach {
            view.addSubview($0)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        gender.inputView = pickerView
        
        setupConstraints()
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    @objc func goNext() {
        
        if let gender = gender.text {
            OnboardingControls().updateGender(gender: gender)
        }
        
        navigationController?.pushViewController(BirthdayVC(), animated: false)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            genderImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            genderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderImage.heightAnchor.constraint(equalToConstant: 160),
            
            gender.topAnchor.constraint(equalTo: genderImage.bottomAnchor,constant: 20),
            gender.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gender.widthAnchor.constraint(equalToConstant: 350),
            gender.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
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
        gender.text = genders[row]
        gender.resignFirstResponder()
    }
}
