//
//  ProfileDetailsOnBoardingViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit

class ProfileDetailsOnBoardingViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
        
    lazy var profileCompletionLabel: UILabel = {
       let profileCompletionLabel = UILabel()
       profileCompletionLabel.text = "Complete your Profile"
       profileCompletionLabel.font =  UIFont(name: "Rightwood", size: 45)
       profileCompletionLabel.textColor = UIColor(named: "mainPage")
       profileCompletionLabel.textAlignment = .center
       profileCompletionLabel.translatesAutoresizingMaskIntoConstraints = false
       return profileCompletionLabel
    }()
    
    lazy var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: CGRectMake(0,0,150,150))
       profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
       profileImage.image = UIImage(named: "blankPhoto")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       return profileImage
    }()
        
    lazy var genderLabel: UILabel = {
       let genderLabel = UILabel()
        genderLabel.text = "Gender"
        genderLabel.font =  UIFont.systemFont(ofSize: 20)
        genderLabel.textColor = UIColor(named: "mainPage")
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
       return genderLabel
    }()
    
    let genderOption: UISegmentedControl = {
        let genderOption = UISegmentedControl(items: ["MALE","FEMALE"])
        genderOption.translatesAutoresizingMaskIntoConstraints = false
        genderOption.heightAnchor.constraint(equalToConstant: 35).isActive  = true
        genderOption.selectedSegmentIndex = 0
        return genderOption
    }()
    
    lazy var mailID: UILabel = {
       let mailID = UILabel()
        mailID.text = "Your mail-id"
        mailID.font =  UIFont.systemFont(ofSize: 20)
        mailID.textColor = UIColor(named: "mainPage")
        mailID.translatesAutoresizingMaskIntoConstraints = false
       return mailID
    }()

    let emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.clearsOnBeginEditing = true
        email.layer.cornerRadius = 10
        email.layer.borderWidth = 2
        email.layer.borderColor = UIColor(named: "mainPage")?.cgColor
        email.clearButtonMode = .whileEditing
        email.setImageInTextFieldOnLeft(imageName: "mail.png")
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    lazy var ageLabel: UILabel = {
       let ageLabel = UILabel()
        ageLabel.text = "Your age"
        ageLabel.font =  UIFont.systemFont(ofSize: 20)
        ageLabel.textColor = UIColor(named: "mainPage")
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
       return ageLabel
    }()

    let ageTextField: UITextField = {
        let ageTextField = UITextField()
        ageTextField.placeholder = ""
        ageTextField.clearsOnBeginEditing = true
        ageTextField.layer.cornerRadius = 10
        ageTextField.layer.borderWidth = 2
        ageTextField.layer.borderColor = UIColor(named: "mainPage")?.cgColor
        ageTextField.clearButtonMode = .whileEditing
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        return ageTextField
    }()
    
    lazy var finishButton: UIButton = {
        let finishButton = UIButton()
        finishButton.setTitle("FINISH", for: .normal)
        finishButton.setTitleColor(UIColor(named: "mainPage"), for: .normal)
        finishButton.backgroundColor = .systemBlue
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderWidth = 2
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.isEnabled = true
        finishButton.alpha = 1.0
        return finishButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
    //    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SKIP", style: .plain, target: self, action: #selector(validateUserCredentials))
        view.backgroundColor = .systemBackground
        
        [profileCompletionLabel,profilePhoto,genderLabel,genderOption,mailID,emailTextField,ageLabel,ageTextField,finishButton].forEach {
            view.addSubview($0)
        }
        
        
        
        setConstraints()
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress))
        profilePhoto.addGestureRecognizer(imagePicker)
        
        profilePhoto.image = profilePhoto.image?.loadImageFromDiskWith(fileName: "ProfileDP")
       // finishButton.addTarget(self, action: #selector(validateUserCredentials), for: .touchUpInside)
    }
    
    @objc func goToHomePage() {
        navigationController?.pushViewController(HomePageViewController(), animated: true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            profileCompletionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            profileCompletionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            profileCompletionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25),
            profileCompletionLabel.heightAnchor.constraint(equalToConstant: 50),
            
            profilePhoto.topAnchor.constraint(equalTo: profileCompletionLabel.bottomAnchor,constant: 50),
            profilePhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 120),
            profilePhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -120),
            profilePhoto.heightAnchor.constraint(equalToConstant: 150),
            
            genderLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 30),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genderOption.topAnchor.constraint(equalTo: genderLabel.bottomAnchor,constant: 10),
            genderOption.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            genderOption.heightAnchor.constraint(equalToConstant: 100),
            
            mailID.topAnchor.constraint(equalTo: genderOption.bottomAnchor,constant: 30),
            mailID.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            mailID.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mailID.heightAnchor.constraint(equalToConstant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: mailID.bottomAnchor,constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            ageLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 30),
            ageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            ageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ageLabel.heightAnchor.constraint(equalToConstant: 20),
            
            ageTextField.topAnchor.constraint(equalTo: ageLabel.bottomAnchor,constant: 10),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            finishButton.topAnchor.constraint(equalTo: ageTextField.bottomAnchor,constant: 50),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    @objc func imagePress() {
        
        let imagePicker = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            print("CAMERA")
            self.showImagePicker(selectedSource: .camera)
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
            print("LIBRARY")
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
}

extension UIImage {
    func saveImage(imageName: String, image: UIImage) {

     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
}
