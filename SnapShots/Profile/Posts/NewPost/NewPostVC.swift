//
//  PostViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 17/11/22.
//

import UIKit

class NewPostVC: UIViewController {
    
    var newPostControls: NewPostControls!
    
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
       caption.text = "Write a caption..."
       caption.textColor = .gray
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
        uploadLabel.isUserInteractionEnabled = true
        return uploadLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadLabel)
        
        [postImage,captionLabel,caption].forEach {
            view.addSubview($0)
        }
        
        setupProfileConstraints()
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress(_:)))
        postImage.addGestureRecognizer(imagePicker)
        
        let uploadTap = UITapGestureRecognizer(target: self, action: #selector(uploadPost(_:)))
        uploadLabel.addGestureRecognizer(uploadTap)
    }
    
    func setupProfileConstraints() {
        
        NSLayoutConstraint.activate([
            
            postImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            postImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            postImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            postImage.heightAnchor.constraint(equalToConstant: 300),
            
            captionLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor,constant: 20),
            captionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            captionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            captionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            caption.topAnchor.constraint(equalTo: captionLabel.bottomAnchor),
            caption.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            caption.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            caption.heightAnchor.constraint(equalToConstant: 100)
        
        ])
    }
    
    @objc func uploadPost(_ sender : UITapGestureRecognizer) {
        newPostControls.addPost(caption: caption.text, image: postImage.image!)
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension NewPostVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func imagePress(_ sender : UITapGestureRecognizer) {

        let imagePicker = UIAlertController(title: "CHANGE DP", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showImagePicker(selectedSource: .camera)
        }

        let gallery = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        }

        let removeDP = UIAlertAction(title: "Remove", style: .default) { _ in
            self.postImage.image = UIImage(named: "blankPhoto")
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
            postImage.image = selectedImage
        } else {
            print("Image not found")
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
