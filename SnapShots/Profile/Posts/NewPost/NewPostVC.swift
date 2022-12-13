//
//  PostViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 17/11/22.
//

import UIKit

class NewPostVC: UIViewController {
    
    private var isPhotoUploaded: Bool = false
    private var newPostControls: NewPostControlProtocol
    
    init(newPostControls: NewPostControlProtocol) {
        self.newPostControls = newPostControls
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
    
    private lazy var postImage: UIImageView = {
       let postImage = UIImageView(frame: .zero)
        postImage.image = UIImage(named: "blankPhoto")
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFill
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.isUserInteractionEnabled = true
       return postImage
    }()
    
    private lazy var captionLabel: UILabel = {
       let captionLabel = UILabel()
       captionLabel.text = "Caption:"
       captionLabel.textColor = .gray
       captionLabel.font = UIFont.systemFont(ofSize: 20)
       captionLabel.translatesAutoresizingMaskIntoConstraints = false
       return captionLabel
    }()
    
    private lazy var caption: UITextView = {
       let caption = UITextView()
       caption.textColor = UIColor(named: "appTheme")
       caption.font = UIFont.systemFont(ofSize: 16)
       caption.translatesAutoresizingMaskIntoConstraints = false
       caption.layer.borderWidth = 1.0
       caption.layer.borderColor = UIColor.gray.cgColor
       return caption
    }()
    
    private lazy var uploadLabel: UILabel = {
       let uploadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        uploadLabel.text = "Upload"
        uploadLabel.textColor = .systemBlue
        uploadLabel.isUserInteractionEnabled = false
        uploadLabel.alpha = 0.5
        return uploadLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        setupNavigationItems()
        setupTapGestures()
        setupProfileConstraints()
        setupNotificationCenter()
    }
    
    private func setupNavigationItems()  {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadLabel)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupTapGestures() {
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress(_:)))
        postImage.addGestureRecognizer(imagePicker)
        
        let uploadTap = UITapGestureRecognizer(target: self, action: #selector(uploadPost(_:)))
        uploadLabel.addGestureRecognizer(uploadTap)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func setupProfileConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [postImage,captionLabel,caption].forEach {
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
            
            postImage.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 30),
            postImage.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 30),
            postImage.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -30),
            postImage.heightAnchor.constraint(equalToConstant: 300),
            
            captionLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 20),
            captionLabel.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 30),
            captionLabel.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -30),
            captionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            caption.topAnchor.constraint(equalTo: captionLabel.bottomAnchor),
            caption.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 30),
            caption.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -30),
            caption.heightAnchor.constraint(equalToConstant: 100),
            caption.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        
        ])
    }
    
    @objc private func uploadPost(_ sender : UITapGestureRecognizer) {
        
        if !newPostControls.addPost(caption: caption.text, image: postImage.image!) {
            showToast(message: Constants.toastFailureStatus)
            return
        }
        
        NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
        self.navigationController?.popViewController(animated: true)
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

extension NewPostVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePress(_ sender : UITapGestureRecognizer) {

        let imagePicker = UIAlertController(title: "CHANGE DP", message: nil, preferredStyle: .actionSheet)
        

        imagePicker.addAction(
            UIAlertAction(title: "Camera", style: .default) { _ in
                self.showImagePicker(selectedSource: .camera)
        })
        
        imagePicker.addAction(
            UIAlertAction(title: "Gallery", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        })
        
        imagePicker.addAction(
            UIAlertAction(title: "Remove", style: .default) { _ in
                self.postImage.image = UIImage(named: "blankPhoto")
                self.uploadLabel.isUserInteractionEnabled = false
                self.uploadLabel.alpha = 0.5
            }
        )
        
        imagePicker.addAction(
            UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        )
        
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
            postImage.image = selectedImage
            isPhotoUploaded = true
            uploadLabel.alpha = 1.0
            uploadLabel.isUserInteractionEnabled = true
        } else {
            print("Image not found")
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
