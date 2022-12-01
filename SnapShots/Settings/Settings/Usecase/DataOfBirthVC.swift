//
//  DataOfBirthVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import UIKit

class DataOfBirthVC: UIViewController {
    
    private var birthdayLogo: UIImageView = {
        let birthdayLogo = UIImageView(frame: .zero)
        birthdayLogo.image = UIImage(systemName: "birthday.cake")
        birthdayLogo.clipsToBounds = true
        birthdayLogo.contentMode = .scaleAspectFit
        birthdayLogo.translatesAutoresizingMaskIntoConstraints = false
        birthdayLogo.isUserInteractionEnabled = false
        birthdayLogo.tintColor = UIColor(named: "appTheme")
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
    
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func updateBirthday() {
        
        if let birthday = dateOfBirth.text,!birthday.isEmpty {
            if AccountControls().updateBirthday(birthday: birthday) {
                dateOfBirth.layer.borderColor = UIColor.red.cgColor
            }
           return
        }
        navigationController?.pushViewController(OnboardingBioVC(), animated: false)
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
            
        ])
    }
}
