//
//  ProfileHeaderCollectionReusableView.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func controller() -> ProfileVC
    func getFriendsList()
    func sendFriendRequest()
    func cancelFriendRequest()
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    private var portraitConstraint = [NSLayoutConstraint]()
    
    // MARK: SETUP LANDSCAPE CONSTRAINTS
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
    
    private lazy var postContainer: UIView = {
       var postContainer = UIView()
       postContainer.translatesAutoresizingMaskIntoConstraints = false
        postContainer.clipsToBounds = true
        postContainer.layer.cornerRadius = 10
        postContainer.layer.borderWidth = 0.5
        postContainer.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        postContainer.backgroundColor = UIColor(named: "post_bg_color")
       return postContainer
    }()
    
    var postsLabel: UILabel = {
       var postsLabel = UILabel()
        postsLabel.translatesAutoresizingMaskIntoConstraints = false
       postsLabel.attributedText = NSAttributedString(string: "Post",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
       return postsLabel
    }()
    
    var postsCountLabel: UILabel = {
       var postsCountLabel = UILabel()
       postsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        postsCountLabel.textAlignment = .right
       postsCountLabel.attributedText = NSAttributedString(string: "10",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
       return postsCountLabel
    }()
    
    private lazy var friendsContainer: UIView = {
       var friendsContainer = UIView()
        friendsContainer.translatesAutoresizingMaskIntoConstraints = false
        friendsContainer.clipsToBounds = true
        friendsContainer.layer.cornerRadius = 10
        friendsContainer.layer.borderWidth = 0.5
        friendsContainer.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        friendsContainer.backgroundColor = UIColor(named: "post_bg_color")
       return friendsContainer
    }()
    
    var friendsLabel: UILabel = {
       var friendsLabel = UILabel()
       friendsLabel.translatesAutoresizingMaskIntoConstraints = false
       friendsLabel.attributedText = NSAttributedString(string: "Friends",attributes: [
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
        friendsCountLabel.textAlignment = .right
       return friendsCountLabel
    }()
    
    private lazy var profileAccessButton: UIButton = {
        let profileAccessButton = UIButton()
        profileAccessButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        profileAccessButton.backgroundColor = UIColor(named: "post_bg_color")
        profileAccessButton.translatesAutoresizingMaskIntoConstraints = false
        profileAccessButton.layer.cornerRadius = 10
        profileAccessButton.layer.borderWidth = 0.5
        profileAccessButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        profileAccessButton.titleLabel?.numberOfLines = 2
        profileAccessButton.setTitleColor( UIColor(named: "appTheme")! , for: .normal)
        return profileAccessButton
    }()
    
    private lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.font =  UIFont.boldSystemFont(ofSize: 25)
       return userNameLabel
    }()
    
    private lazy var bioLabel: UILabel = {
        var bioLabel = UILabel()
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.numberOfLines = 5
        bioLabel.font = UIFont.boldSystemFont(ofSize: 12)
        return bioLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileAccessButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        [profilePhoto,postContainer,friendsContainer,userNameLabel,bioLabel,profileAccessButton].forEach {
            self.addSubview($0)
        }
        
        [postsLabel,postsCountLabel].forEach {
            postContainer.addSubview($0)
        }
        
        [friendsLabel,friendsCountLabel].forEach {
            friendsContainer.addSubview($0)
        }
        
        setupConstraint()
        profilePhoto.layer.cornerRadius = 60
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(imagePress(_:)))
        profilePhoto.addGestureRecognizer(imagePicker)
        
        let openFriendsTap = UITapGestureRecognizer(target: self, action: #selector(showFriends(_:)))
        friendsContainer.addGestureRecognizer(openFriendsTap)
        
        if traitCollection.verticalSizeClass == .compact {
            setPortraitConstraints()
        } else {
            setPortraitConstraints()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(username: String,friendsCount: Int,postsCount: Int,bio: String,profileDP: UIImage,profileAccessibility: ProfileAccess) {
        userNameLabel.text = username
        friendsCountLabel.text = String(friendsCount)
        postsCountLabel.text = String(postsCount)
        bioLabel.text = bio.isEmpty ? "Nothing to share!" : bio
        profilePhoto.image = profileDP
        
        if profileAccessibility == .friend {
            setupFriendProfile()
        } else if profileAccessibility == .owner {
            setupOwnerProfile()
        } else {
            setupAcquaintanceProfile()
        }
    }
    
    func setupOwnerProfile() {
        profileAccessButton.setTitle(" Edit\nProfile", for: .normal)
        profileAccessButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
    }
    
    func setupFriendProfile() {
        profileAccessButton.setTitle("Unfriend", for: .normal)
        profileAccessButton.addTarget(self, action: #selector(unFollowUser), for: .touchUpInside)
        profileAccessButton.backgroundColor = .systemBlue
    }
    
    func setupAcquaintanceProfile() {
        profileAccessButton.setTitle("Follow", for: .normal)
        profileAccessButton.addTarget(self, action: #selector(sendFriendRequest), for: .touchUpInside)
        profileAccessButton.backgroundColor = .systemBlue
       
    }

    @objc func editProfile() {
        // MARK: EDITING THE PROFILE LOGIC HERE
        print("Editing Profile")
    }
    
    @objc func sendFriendRequest() {
        delegate?.sendFriendRequest()
    }
    
    @objc func unFollowUser() {
        // MARK: UNFRIENDING A USER
        //delegate
    }
    
    @objc func showFriends(_ sender : UITapGestureRecognizer) {
        delegate?.getFriendsList()
    }
}

// MARK: IMAGE PICKER
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
            let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
            selectedImage.saveImage(imageName: "\(Constants.dpSavingFormat)\(userID)", image: selectedImage)
            profilePhoto.image = selectedImage
            print("Image changed")
        } else {
            print("Image not found")
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


// MARK: TRAIT COLLECTION AND IMAGE PICKING
extension ProfileHeaderCollectionReusableView {
    
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


// MARK: CONSTRAINTS
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
            profilePhoto.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 125),
            profilePhoto.heightAnchor.constraint(equalToConstant: 120),
            profilePhoto.widthAnchor.constraint(equalTo: profilePhoto.heightAnchor),
            
            postContainer.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 30),
            postContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            postContainer.widthAnchor.constraint(equalToConstant: 110),
            postContainer.heightAnchor.constraint(equalToConstant: 55),
            
            postsLabel.topAnchor.constraint(equalTo: postContainer.topAnchor),
            postsLabel.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 8),
            postsLabel.trailingAnchor.constraint(equalTo:postContainer.trailingAnchor),
            postsLabel.heightAnchor.constraint(equalToConstant: 25),
            
            postsCountLabel.topAnchor.constraint(equalTo: postsLabel.bottomAnchor,constant: 4),
            postsCountLabel.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor),
            postsCountLabel.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor,constant: -8),
            postsCountLabel.heightAnchor.constraint(equalToConstant: 25),
            
            friendsContainer.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 30),
            friendsContainer.leadingAnchor.constraint(equalTo: postContainer.trailingAnchor,constant: 10),
            friendsContainer.widthAnchor.constraint(equalToConstant: 110),
            friendsContainer.heightAnchor.constraint(equalToConstant: 55),
            
            friendsLabel.topAnchor.constraint(equalTo: friendsContainer.topAnchor),
            friendsLabel.leadingAnchor.constraint(equalTo: friendsContainer.leadingAnchor,constant: 8),
            friendsLabel.trailingAnchor.constraint(equalTo:friendsContainer.trailingAnchor),
            friendsLabel.heightAnchor.constraint(equalToConstant: 25),
            
            friendsCountLabel.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor,constant: 4),
            friendsCountLabel.leadingAnchor.constraint(equalTo: friendsContainer.leadingAnchor),
            friendsCountLabel.trailingAnchor.constraint(equalTo: friendsContainer.trailingAnchor,constant: -8),
            friendsCountLabel.heightAnchor.constraint(equalToConstant: 25),
            
            profileAccessButton.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 30),
            profileAccessButton.leadingAnchor.constraint(equalTo: friendsContainer.trailingAnchor,constant: 10),
            profileAccessButton.widthAnchor.constraint(equalToConstant: 115),
            profileAccessButton.heightAnchor.constraint(equalToConstant: 55),
            
            userNameLabel.topAnchor.constraint(equalTo: postContainer.bottomAnchor,constant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            userNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            bioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 4),
            bioLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            bioLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            bioLabel.heightAnchor.constraint(equalToConstant: 30),
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

            friendsCountLabel.topAnchor.constraint(equalTo: postsLabel.bottomAnchor,constant: 20),
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
