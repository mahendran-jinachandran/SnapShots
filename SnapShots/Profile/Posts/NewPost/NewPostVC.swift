//
//  PostViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 17/11/22.
//

import UIKit
import UserNotifications

class NewPostVC: UIViewController,UITextViewDelegate {
    
    private var isPhotoUploaded: Bool = false
    private var isCaptionGiven: Bool = false
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
        postImage.image = UIImage(systemName: "photo.on.rectangle.angled")
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFit
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.isUserInteractionEnabled = true
        postImage.tintColor = .lightGray
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
        uploadLabel.isUserInteractionEnabled = false
        uploadLabel.alpha = 0.5
        return uploadLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationItems()
        setupTapGestures()
        setupProfileConstraints()
        setupNotificationCenter()
        
        caption.delegate = self
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView == caption,!caption.text.isEmpty {
            isCaptionGiven = true
        } else {
            isCaptionGiven = false
        }
    }
    
    private func setupNavigationItems()  {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Add Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadLabel)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "appTheme")
    }
    
    @objc private func goBack() {
        
        if isPhotoUploaded || isCaptionGiven {
            let abortPostUpload = UIAlertController(title: "Unsaved changes", message: "Are you sure you want to cancel?", preferredStyle: .alert)
            
            abortPostUpload.addAction(
                UIAlertAction(title: "Yes", style: .default) { _ in
                    self.dismiss(animated: true)
                }
            )
            
            abortPostUpload.addAction(
                UIAlertAction(title: "No", style: .cancel)
            )
            
            present(abortPostUpload, animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    private func setupTapGestures() {
        postImage.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(imagePress(_:)))
        )
        
        uploadLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(uploadPost(_:)))
        )
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
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
            postImage.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
            postImage.widthAnchor.constraint(equalToConstant: 240),
            postImage.heightAnchor.constraint(equalToConstant: 200),
            
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
        
        if !newPostControls.addPost(caption: caption.text!.trimmingCharacters(in: .whitespacesAndNewlines), image: postImage.image!) {
            
            
            showToast(message: Constants.toastFailureStatus)
            return
        }
        
        NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
        sendLocalNotifications()
        self.dismiss(animated: true)
    }
    
    func sendLocalNotifications() {
        
        let center = UNUserNotificationCenter.current()
        
       
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted,error) in
            if error == nil {
                print("User permission is granted: \(granted)")
            } else {
                print("Not granted")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Snapshots"
        content.body = "Uploaded a new post"
        
        let date = Date().addingTimeInterval(10)
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print("Error")
        }
    }
    
    @objc private func handleKeyboard(_ notification: Notification) {
        
        var scrollViewMovingOffsetY: CGFloat = 0
        
        if notification.name == UIResponder.keyboardDidHideNotification {
            scrollView.contentInset = .zero
        }
        
        if notification.name != UIResponder.keyboardDidHideNotification, let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            let scrollViewMaxY = self.view.convert(
                scrollView.frame,
                to: nil
            ).maxY
            
            scrollViewMovingOffsetY = -(scrollViewMaxY - keyboardFrame.minY) + scrollViewMovingOffsetY + scrollView.contentInset.bottom
            
            if let keyWindow = view.window {
                scrollViewMovingOffsetY -= (UIScreen.main.bounds.height - keyWindow.frame.height) / 2
            }
        }
        
        let keyboardAwareInset = UIEdgeInsets(
            top: scrollView.contentInset.top,
            left: scrollView.contentInset.left,
            bottom: scrollView.contentInset.bottom + abs(scrollViewMovingOffsetY),
            right: scrollView.contentInset.right
        )
        scrollView.contentInset = keyboardAwareInset
        
        var firstResponderView: UIView? = nil
        if caption.isFirstResponder {
            firstResponderView = caption
        } else if caption.isFirstResponder {
            firstResponderView = caption
        }

        UIView.animate(withDuration: notification.name == UIResponder.keyboardDidShowNotification ? 0 : 0.25) {[weak self] in
            self?.view.layoutIfNeeded()
        } completion: {[weak self] finished in
            guard let self = self else { return }

            if let focusedView = firstResponderView {
                if self.scrollView.isDecelerating { return }
                    self.scrollView.scrollRectToVisible(focusedView.superview!.frame, animated: true)

            }
        }
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
        
        if isPhotoUploaded {
            imagePicker.addAction(
                UIAlertAction(title: "Remove", style: .default) { _ in
                    self.isPhotoUploaded = false
                    self.postImage.image = UIImage(systemName: "photo.on.rectangle.angled")
                    self.uploadLabel.isUserInteractionEnabled = false
                    self.uploadLabel.alpha = 0.5
                }
            )
        }
        
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
