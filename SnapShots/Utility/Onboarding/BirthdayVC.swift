//
//  DOBViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class BirthdayVC: UIViewController {
    
    private var birthdayLogo: UIImageView = {
        let birthdayLogo = UIImageView(frame: .zero)
        birthdayLogo.image = UIImage(systemName: "birthday.cake")
        birthdayLogo.clipsToBounds = true
        birthdayLogo.contentMode = .scaleAspectFit
        birthdayLogo.translatesAutoresizingMaskIntoConstraints = false
        birthdayLogo.isUserInteractionEnabled = false
        birthdayLogo.tintColor = UIColor(named: "mainPage")
        return birthdayLogo
    }()

    private lazy var dateOfBirth: UITextField = {
        let dateOfBirth = UITextField()
        dateOfBirth.placeholder = "Birthday"
        dateOfBirth.layer.cornerRadius = 5
        dateOfBirth.layer.borderWidth = 2
        dateOfBirth.layer.borderColor = UIColor.gray.cgColor
        dateOfBirth.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirth.textAlignment = .center
        return dateOfBirth
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
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .systemBackground
        [birthdayLogo,dateOfBirth,nextButton].forEach {
            view.addSubview($0)
        }
        
        setConstraints()
        setupDatePicker()
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    @objc func goNext() {
        
        if let birthday = dateOfBirth.text {
             OnboardingControls().updateBirthday(birthday: birthday) 
        }
        
        navigationController?.pushViewController(BioVC(), animated: false)
    }
    
    func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateOfBirth.inputView = datePicker
        dateOfBirth.inputAccessoryView = createToolBar()
    }
    
    func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addBirthday))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @objc func addBirthday() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateOfBirth.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            birthdayLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            birthdayLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            birthdayLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            birthdayLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50),
            birthdayLogo.heightAnchor.constraint(equalToConstant: 160),
            
            dateOfBirth.topAnchor.constraint(equalTo: birthdayLogo.bottomAnchor,constant: 20),
            dateOfBirth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateOfBirth.widthAnchor.constraint(equalToConstant: 350),
            dateOfBirth.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
