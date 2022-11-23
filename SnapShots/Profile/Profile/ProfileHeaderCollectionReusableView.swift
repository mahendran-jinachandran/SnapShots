//
//  ProfileHeaderCollectionReusableView.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func controller() -> ProfileVC
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    private var portraitConstraint = [NSLayoutConstraint]()
    private var landscapeConstraint = [NSLayoutConstraint]()
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "blankPhoto")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       return profileImage
    }()
    
    var postsLabel: UILabel = {
       var postsLabel = UILabel()
        postsLabel.translatesAutoresizingMaskIntoConstraints = false
       postsLabel.attributedText = NSAttributedString(string: "POSTS",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
       return postsLabel
    }()
    
    var postsCountLabel: UILabel = {
       var postsCountLabel = UILabel()
       postsCountLabel.translatesAutoresizingMaskIntoConstraints = false
       postsCountLabel.attributedText = NSAttributedString(string: "10",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
       return postsCountLabel
    }()
    
    var friendsLabel: UILabel = {
       var friendsLabel = UILabel()
       friendsLabel.translatesAutoresizingMaskIntoConstraints = false
       friendsLabel.attributedText = NSAttributedString(string: "FRIENDS",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
       return friendsLabel
    }()
    
    var friendsCountLabel: UILabel = {
       var friendsCountLabel = UILabel()
       friendsCountLabel.translatesAutoresizingMaskIntoConstraints = false
       friendsCountLabel.attributedText = NSAttributedString(string: "10",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
       return friendsCountLabel
    }()
    
    private lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.font = UIFont.systemFont(ofSize: 30)
       return userNameLabel
    }()
    
    private lazy var bioLabel: UILabel = {
       var bioLabel = UILabel()
       bioLabel.translatesAutoresizingMaskIntoConstraints = false
       bioLabel.numberOfLines = 5
       return bioLabel
    }()
        
    private lazy var profileAccessButton: UIButton = {
        let profileAccessButton = UIButton()
        profileAccessButton.setTitle("EDIT PROFILE", for: .normal)
        profileAccessButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        profileAccessButton.backgroundColor = .lightGray
        profileAccessButton.translatesAutoresizingMaskIntoConstraints = false
        profileAccessButton.layer.cornerRadius = 5.0
        profileAccessButton.setTitleColor( UIColor(named: "mainPage")! , for: .normal)
       
        return profileAccessButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        profileAccessButton.addTarget(self, action: #selector(showName), for: .touchUpInside)
        
        [profilePhoto,postsLabel,postsCountLabel,friendsLabel,friendsCountLabel,userNameLabel,bioLabel,profileAccessButton].forEach {
            self.addSubview($0)
        }
        
        setupConstraint()
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress(_:)))
        profilePhoto.addGestureRecognizer(imagePicker)
        
        if traitCollection.verticalSizeClass == .compact {
            setLandscapeConstraints()
        } else {
            setPortraitConstraints()
        }
        

    }
    
    func setData(username: String,friendsCount: String,postsCount: String,bio: String) {
        userNameLabel.text = username
        friendsCountLabel.text = friendsCount
        postsCountLabel.text = postsCount
        
        if bio == "-1" {
//            bioLabel.isHidden = true
//            bioLabel.removeFromSuperview()
            
        } else {
            bioLabel.text = bio

        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showName() {
        print("Done")
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if traitCollection.verticalSizeClass == .compact {
            setLandscapeConstraints()
        } else {
            setPortraitConstraints()
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = systemLayoutSizeFitting(layoutAttributes.size)
        layoutAttributes.size = size
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
    
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
        
        delegate?.controller().present(imagePicker, animated: true,completion: nil)
    }

}

extension ProfileHeaderCollectionReusableView: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            print("Selected source not available")
            return
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false

        delegate?.controller().present(imagePickerController, animated: true)
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

extension ProfileHeaderCollectionReusableView {
    
    func setPortraitConstraints() {
        NSLayoutConstraint.deactivate(landscapeConstraint)
        NSLayoutConstraint.activate(portraitConstraint)
    }
    
    func setLandscapeConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraint)
        NSLayoutConstraint.activate(landscapeConstraint)
    }
    
    private func setupConstraint() {
    
        portraitConstraint.append(contentsOf: [
            
            profilePhoto.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 10),
            profilePhoto.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            profilePhoto.heightAnchor.constraint(equalToConstant: 100),
            profilePhoto.widthAnchor.constraint(equalTo: profilePhoto.heightAnchor),
            
            postsLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor, constant: 10),
            postsLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor, constant: 65),
            postsLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            postsCountLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor, constant: -15),
            postsCountLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor, constant: 80),
            postsCountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            friendsLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor,constant: 10),
            friendsLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 165),
            friendsLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            friendsCountLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor, constant: -15),
            friendsCountLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor, constant: 185),
            friendsCountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            bioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 10),
            bioLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            bioLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            bioLabel.heightAnchor.constraint(equalToConstant: 50),
            
            profileAccessButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor,constant: 20),
            profileAccessButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            profileAccessButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            profileAccessButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
       landscapeConstraint.append(contentsOf: [

            profilePhoto.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 10),
            profilePhoto.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            profilePhoto.heightAnchor.constraint(equalToConstant: 200),
            profilePhoto.widthAnchor.constraint(equalTo: profilePhoto.heightAnchor),

            userNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant:15),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 40),
            userNameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 50),

            bioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            bioLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 40),
            bioLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            bioLabel.heightAnchor.constraint(equalToConstant: 50),

            postsLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
            postsLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor, constant: 40),
            postsLabel.heightAnchor.constraint(equalToConstant: 20),
            postsLabel.widthAnchor.constraint(equalToConstant: 75),

            postsCountLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor,constant: 20),
            postsCountLabel.leadingAnchor.constraint(equalTo: postsLabel.trailingAnchor),
            postsCountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            postsCountLabel.heightAnchor.constraint(equalToConstant: 20),

            friendsLabel.topAnchor.constraint(equalTo: postsLabel.bottomAnchor,constant: 10),
            friendsLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor, constant: 40),
            friendsLabel.heightAnchor.constraint(equalToConstant: 20),
            friendsLabel.widthAnchor.constraint(equalToConstant: 75),

            friendsCountLabel.topAnchor.constraint(equalTo: postsLabel.bottomAnchor,constant: 10),
            friendsCountLabel.leadingAnchor.constraint(equalTo: friendsLabel.trailingAnchor),
            friendsCountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            friendsCountLabel.heightAnchor.constraint(equalToConstant: 20),

            profileAccessButton.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 20),
            profileAccessButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            profileAccessButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            profileAccessButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
