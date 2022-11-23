//
//  ProfileDetailsOnBoardingViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit

class ProfileCompletionVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private var profileCompletionStackView: UIStackView!
    private lazy var profileCompletionScrollView: UIScrollView = {
        let profileCompletionScrollView = UIScrollView()
        profileCompletionScrollView.translatesAutoresizingMaskIntoConstraints = false
        profileCompletionScrollView.decelerationRate = .fast
        profileCompletionScrollView.backgroundColor = .systemBackground
        return profileCompletionScrollView
    }()
        
    private lazy var profileCompletionLabel: UILabel = {
       let profileCompletionLabel = UILabel()
       profileCompletionLabel.text = "Complete your Profile"
       profileCompletionLabel.font =  UIFont(name: "Rightwood", size: 45)
       profileCompletionLabel.textColor = UIColor(named: "mainPage")
       profileCompletionLabel.textAlignment = .center
       profileCompletionLabel.translatesAutoresizingMaskIntoConstraints = false
       profileCompletionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
       return profileCompletionLabel
    }()
    
    private lazy var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: CGRectMake(0,0,150,150))
       profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
       profileImage.image = UIImage(named: "blankPhoto")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFit
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
       profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
       return profileImage
    }()
        
    private lazy var genderLabel: UILabel = {
       let genderLabel = UILabel()
       genderLabel.text = "Gender"
       genderLabel.font =  UIFont.systemFont(ofSize: 20)
       genderLabel.textColor = UIColor(named: "mainPage")
       genderLabel.translatesAutoresizingMaskIntoConstraints = false
       genderLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
       return genderLabel
    }()
    
    private lazy var genderOption: UISegmentedControl = {
        let genderOption = UISegmentedControl(items: ["Rather not say","Male","Female"])
        genderOption.translatesAutoresizingMaskIntoConstraints = false
        genderOption.heightAnchor.constraint(equalToConstant: 50).isActive  = true
        genderOption.selectedSegmentIndex = 0
        return genderOption
    }()
    
    private lazy var mailID: UILabel = {
       let mailID = UILabel()
        mailID.text = "Mail-id"
        mailID.font =  UIFont.systemFont(ofSize: 20)
        mailID.textColor = UIColor(named: "mainPage")
        mailID.translatesAutoresizingMaskIntoConstraints = false
        mailID.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return mailID
    }()

    private lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.clearsOnBeginEditing = true
        email.layer.cornerRadius = 10
        email.layer.borderWidth = 2
        email.layer.borderColor = UIColor.gray.cgColor
        email.clearButtonMode = .whileEditing
        email.setImageInTextFieldOnLeft(imageName: "mail.png")
        email.translatesAutoresizingMaskIntoConstraints = false
        email.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return email
    }()
    
    lazy var ageLabel: UILabel = {
       let ageLabel = UILabel()
        ageLabel.text = "Age"
        ageLabel.font =  UIFont.systemFont(ofSize: 20)
        ageLabel.textColor = UIColor(named: "mainPage")
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
       return ageLabel
    }()

    private lazy var ageTextField: UITextField = {
        let ageTextField = UITextField()
        ageTextField.placeholder = "Enter your age"
        ageTextField.clearsOnBeginEditing = true
        ageTextField.layer.cornerRadius = 10
        ageTextField.layer.borderWidth = 2
        ageTextField.layer.borderColor = UIColor.gray.cgColor
        ageTextField.clearButtonMode = .whileEditing
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: ageTextField.frame.height))
        ageTextField.leftViewMode = .always
        return ageTextField
    }()
    
    lazy var bioLabel: UILabel = {
       let bioLabel = UILabel()
        bioLabel.text = "Bio"
        bioLabel.font =  UIFont.systemFont(ofSize: 20)
        bioLabel.textColor = UIColor(named: "mainPage")
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
       return bioLabel
    }()
    
    private lazy var bioTextField: UITextField = {
        let bioTextField = UITextField()
        bioTextField.placeholder = "About you..."
        bioTextField.clearsOnBeginEditing = true
        bioTextField.layer.cornerRadius = 10
        bioTextField.layer.borderWidth = 2
        bioTextField.layer.borderColor = UIColor.gray.cgColor
        bioTextField.clearButtonMode = .whileEditing
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        bioTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bioTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: bioTextField.frame.height))
        bioTextField.leftViewMode = .always
        return bioTextField
    }()
    
    
    
    private lazy var finishButton: UIButton = {
        let finishButton = UIButton()
        finishButton.setTitle("FINISH", for: .normal)
        finishButton.setTitleColor(UIColor(named: "mainPage"), for: .normal)
        finishButton.backgroundColor = .systemBlue
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderWidth = 2
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.isEnabled = true
        finishButton.alpha = 1.0
        finishButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return finishButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .systemBackground
        
        createProfileCompletionStackView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let screenTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress))
        profilePhoto.addGestureRecognizer(imagePicker)
        
        finishButton.addTarget(self, action: #selector(completeProfile), for: .touchUpInside)
    }
    
    @objc func completeProfile() {
        
        var gender: Gender?
        let mailID: String? = emailTextField.text!.count > 0 ? emailTextField.text:nil
        let age = Int(ageTextField.text!)
        let bio: String? = bioTextField.text!.count > 0 ? bioTextField.text : nil
        
        if genderOption.selectedSegmentIndex == 0 {
            gender = .ratherNotSay
        } else if genderOption.selectedSegmentIndex == 1 {
            gender = .male
        } else if genderOption.selectedSegmentIndex == 2 {
            gender = .female
        }
        
        let profile = ProfileCompletionControls()
        profile.finishProfileCompletion(photo: 0, gender: gender, mailID: mailID, age: age,bio: bio)
        
        goToHomePage()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createProfileCompletionStackView() {
        
        let arrangedSubView = [
            profileCompletionLabel,profilePhoto,genderLabel,genderOption,mailID,emailTextField,ageLabel,ageTextField,bioLabel,bioTextField,finishButton
        ]
        
        profileCompletionStackView = UIStackView(arrangedSubviews: arrangedSubView)
        profileCompletionStackView.translatesAutoresizingMaskIntoConstraints = false
        profileCompletionStackView.axis = .vertical
        profileCompletionStackView.distribution = .fill
        profileCompletionStackView.spacing = 15
        
        view.addSubview(profileCompletionScrollView)
        profileCompletionScrollView.addSubview(profileCompletionStackView)
        
        setConstraints()
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            profileCompletionScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            profileCompletionScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -50),
            profileCompletionScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            profileCompletionScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            
            profileCompletionStackView.topAnchor.constraint(equalTo: profileCompletionScrollView.topAnchor),
            profileCompletionStackView.bottomAnchor.constraint(equalTo: profileCompletionScrollView.bottomAnchor),
            profileCompletionStackView.leadingAnchor.constraint(equalTo: profileCompletionScrollView.leadingAnchor),
            profileCompletionStackView.trailingAnchor.constraint(equalTo: profileCompletionScrollView.trailingAnchor),
            profileCompletionStackView.widthAnchor.constraint(equalTo: profileCompletionScrollView.widthAnchor),
            profileCompletionStackView.heightAnchor.constraint(equalTo: profileCompletionScrollView.heightAnchor)
        ])
    }
    
    @objc func goToHomePage() {
        self.view.window?.windowScene?.keyWindow?.rootViewController = HomePageViewController()
    }
    
    @objc func imagePress() {
        
        let imagePicker = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showImagePicker(selectedSource: .camera)
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        imagePicker.addAction(camera)
        imagePicker.addAction(gallery)
        imagePicker.addAction(cancel)
        
        self.present(imagePicker, animated: true,completion: nil)
    }
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            print("Selected source not available")
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImage.saveImage(imageName: "ProfileDP", image: selectedImage)
            profilePhoto.image = selectedImage
        } else {
            print("Image not found")
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
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
            contentInsetBackstore = profileCompletionScrollView.contentInset
        }
        
        profileCompletionScrollView.contentInset = UIEdgeInsets(
            top: contentInsetBackstore.top,
            left: contentInsetBackstore.left,
            bottom: keyboardFrame.height,
            right: contentInsetBackstore.right
        )
    }
    
    @objc private func didKeyboardDisappear(notification:Notification){
        profileCompletionScrollView.contentInset = contentInsetBackstore
        contentInsetBackstore = .zero
    }
}


