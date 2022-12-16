//
//  ViewController.swift
//  OnboardingScreen
//
//  Created by mahendran-14703 on 29/11/22.
//

import UIKit

class OnboardingProfilePhotoVC: UIViewController {
        
    private var isPhotoUploaded: Bool = false
    private var onboardingControls: OnboardingProtocol
    
    init(onboardingControls: OnboardingProtocol) {
        self.onboardingControls = onboardingControls
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
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var scrollContainer: UIView = {
        let scrollContainer = UIView()
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContainer.backgroundColor = .systemBackground
        return scrollContainer
    }()
    
    private lazy var profilePhoto: UIImageView = {
        let profileImage = UIImageView(frame: .zero)
        profileImage.image = UIImage(named: "blankPhoto")
        profileImage.backgroundColor = .systemBlue
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.isUserInteractionEnabled = true
        return profileImage
    }()
    
    private lazy var primaryLabel: UILabel = {
        let primaryLabel = UILabel()
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        primaryLabel.text = "Upload your Profile Picture"
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return primaryLabel
    }()
    
    private lazy var secondaryLabel: UILabel = {
        let secondaryLabel = UILabel()
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.text = "This picture will be used to display\n\t\tfor others to view."
        secondaryLabel.textColor = .systemGray
        secondaryLabel.font = UIFont.systemFont(ofSize: 12)
        secondaryLabel.numberOfLines = 2
        return secondaryLabel
    }()
    
    private lazy var warningLabel: UILabel = {
        let warningLabel = UILabel()
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.text = "Please upload a photo or click skip"
        warningLabel.textColor = .systemRed
        warningLabel.font = UIFont.systemFont(ofSize: 12)
        warningLabel.numberOfLines = 2
        warningLabel.isHidden = true
        return warningLabel
    }()
    
    private lazy var skipButton: UIButton = {
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
        
        setupNavigationItems()
        setupConstraints()
        setupTapGestures()
        
        profilePhoto.layer.cornerRadius = 100
        skipButton.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupTapGestures() {
        skipButton.addTarget(self, action: #selector(navigateToNext), for: .touchUpInside)
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress(_:)))
        profilePhoto.addGestureRecognizer(imagePicker)
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(uploadPhoto))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
    }
    
    @objc private func uploadPhoto() {
        if isPhotoUploaded {
            navigateToNext()
        } else {
            warningLabel.isHidden = false
        }
    }
    
    @objc private func navigateToNext() {
        navigationController?.pushViewController(OnboardingMailVC(onboardingControls: onboardingControls), animated: true)
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        [profilePhoto,primaryLabel,secondaryLabel,warningLabel,skipButton].forEach {
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
            
            profilePhoto.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 50),
            profilePhoto.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 200),
            profilePhoto.heightAnchor.constraint(equalToConstant: 200),
            
            primaryLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 30),
            primaryLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor),
            secondaryLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            
            warningLabel.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor),
            warningLabel.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            
            skipButton.topAnchor.constraint(equalTo: warningLabel.bottomAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -25),
            skipButton.heightAnchor.constraint(equalToConstant: 35),
            skipButton.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor,constant: -30)
        ])
    }
}

extension OnboardingProfilePhotoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc private func imagePress(_ sender : UITapGestureRecognizer) {

        let imagePicker = UIAlertController(title: "CHANGE DP", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showImagePicker(selectedSource: .camera)
        }

        let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        }

        if isPhotoUploaded {
            let removeDP = UIAlertAction(title: "Remove", style: .default) { _ in
                self.profilePhoto.image = UIImage(named: "blankPhoto")
                self.isPhotoUploaded = false
                _ = self.onboardingControls.removeProfilePhoto()
            }
            
            imagePicker.addAction(removeDP)
        }


        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)

        imagePicker.addAction(camera)
        imagePicker.addAction(gallery)
        imagePicker.addAction(cancel)
     
        present(imagePicker, animated: true,completion: nil)
    }
    
    private func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
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

        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        if onboardingControls.updateProfilePhoto(profilePhoto: selectedImage) {
            showToast(message: "DP Updated")
            warningLabel.isHidden = true
            profilePhoto.image = selectedImage
            isPhotoUploaded = true
        } else {
            showToast(message: Constants.toastFailureStatus)
        }
        
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

