//
//  ViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class ProfilePhotoVC: UIViewController {
        
    private var profilePhoto: UIImageView = {
        let profileImage = UIImageView(frame: .zero)
        profileImage.image = UIImage(named: "blankPhoto")
        profileImage.backgroundColor = .systemBlue
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.isUserInteractionEnabled = true
        return profileImage
    }()
    
    private var primaryLabel: UILabel = {
        let primaryLabel = UILabel()
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.text = "Upload your Profile Picture"
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return primaryLabel
    }()
    
    private var secondaryLabel: UILabel = {
        let secondaryLabel = UILabel()
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.text = "This picture will be used to display\n\t\tfor others to view."
        secondaryLabel.textColor = .systemGray
        secondaryLabel.font = UIFont.systemFont(ofSize: 12)
        secondaryLabel.numberOfLines = 2
        return secondaryLabel
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
        view.addSubview(profilePhoto)
        view.addSubview(primaryLabel)
        view.addSubview(secondaryLabel)
        view.addSubview(nextButton)
        
        setupConstraints()
        profilePhoto.layer.cornerRadius = 100
        nextButton.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress(_:)))
        profilePhoto.addGestureRecognizer(imagePicker)
    }
    
    @objc func goToNext() {
        navigationController?.pushViewController(MailVC(), animated: false)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 120),
            profilePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 200),
            profilePhoto.heightAnchor.constraint(equalToConstant: 200),
            
            primaryLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 30),
            primaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryLabel.heightAnchor.constraint(equalToConstant: 50),
            
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
            secondaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -100),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        
        ])
    }
}

extension ProfilePhotoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePress(_ sender : UITapGestureRecognizer) {

        let imagePicker = UIAlertController(title: "CHANGE DP", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showImagePicker(selectedSource: .camera)
        }

        let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        }

        let removeDP = UIAlertAction(title: "Remove", style: .default) { _ in
            self.profilePhoto.image = UIImage(named: "blankPhoto")
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)

        imagePicker.addAction(camera)
        imagePicker.addAction(gallery)
        imagePicker.addAction(cancel)
        imagePicker.addAction(removeDP)
        present(imagePicker, animated: true,completion: nil)
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

        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[.originalImage] as? UIImage {
            profilePhoto.image = selectedImage
            OnboardingControls().updateProfilePhoto(profilePhoto: selectedImage)
        } else {
            print("Image not found")
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

