//
//  ProfileHeaderCollectionReusableView.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func controller() -> ProfileVC
    func uploadPhoto(image: UIImage)
    func removeProfilePhoto()
    func getFriendsList()
    func sendFriendRequest()
    func cancelFriendRequest()
    func unFriendAnUser()
    func editProfile()
    func showPosts()
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private var portraitConstraint = [NSLayoutConstraint]()
    private var profileAccessibility: ProfileAccess!
    private var isPhotoAvailable: Bool = false
    
    private lazy var profileStack : UIStackView = {
        let profileStack = UIStackView()
        profileStack.distribution = .fill
        profileStack.axis = .horizontal
        profileStack.translatesAutoresizingMaskIntoConstraints = false
        profileStack.spacing = 10
        return profileStack
    }()
    
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
        postContainer.addSubview(postsLabel)
        postContainer.addSubview(postsCountLabel)
        NSLayoutConstraint.activate([
            postsCountLabel.topAnchor.constraint(equalTo: postContainer.topAnchor,constant: 10),
            postsCountLabel.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor),
            postsCountLabel.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor),

            postsLabel.topAnchor.constraint(equalTo: postsCountLabel.bottomAnchor,constant: 4),
            postsLabel.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor),
            postsLabel.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor),
            
        ])
        
       return postContainer
    }()
    
    private lazy var postsLabel: UILabel = {
       var postsLabel = UILabel()
        postsLabel.translatesAutoresizingMaskIntoConstraints = false
       postsLabel.attributedText = NSAttributedString(string: "Post",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
        postsLabel.textAlignment = .center
       return postsLabel
    }()
    
    private lazy var postsCountLabel: UILabel = {
       var postsCountLabel = UILabel()
       postsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        postsCountLabel.textAlignment = .right
       postsCountLabel.attributedText = NSAttributedString(string: "10",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
        postsCountLabel.textAlignment = .center
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
        friendsContainer.addSubview(friendsLabel)
        friendsContainer.addSubview(friendsCountLabel)
        
        NSLayoutConstraint.activate([
            friendsCountLabel.topAnchor.constraint(equalTo: friendsContainer.topAnchor,constant: 10),
            friendsCountLabel.leadingAnchor.constraint(equalTo: friendsContainer.leadingAnchor),
            friendsCountLabel.trailingAnchor.constraint(equalTo:friendsContainer.trailingAnchor),
            
            friendsLabel.topAnchor.constraint(equalTo: friendsCountLabel.bottomAnchor,constant: 4),
            friendsLabel.leadingAnchor.constraint(equalTo: friendsContainer.leadingAnchor),
            friendsLabel.trailingAnchor.constraint(equalTo: friendsContainer.trailingAnchor),
        ])
       return friendsContainer
    }()
    
    private lazy var friendsLabel: UILabel = {
       var friendsLabel = UILabel()
       friendsLabel.translatesAutoresizingMaskIntoConstraints = false
       friendsLabel.attributedText = NSAttributedString(string: "Friends",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
        friendsLabel.textAlignment = .center
       return friendsLabel
    }()
    
    private lazy var friendsCountLabel: UILabel = {
       var friendsCountLabel = UILabel()
       friendsCountLabel.translatesAutoresizingMaskIntoConstraints = false
       friendsCountLabel.attributedText = NSAttributedString(string: "10",attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
        friendsCountLabel.textAlignment = .center
       return friendsCountLabel
    }()
    
    private lazy var profileAccessButton: UIButton = {
        let profileAccessButton = CustomButton(selectColour: .systemBlue, deselectColour: .systemBlue)
        profileAccessButton.titleLabel?.text = "Edit \n  Profile"
        profileAccessButton.titleLabel?.textAlignment = .center
        profileAccessButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        profileAccessButton.translatesAutoresizingMaskIntoConstraints = false
        profileAccessButton.backgroundColor = .systemBlue
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
            
        [profilePhoto,profileStack,userNameLabel,bioLabel].forEach {
            self.addSubview($0)
        }
    
        setupStackView()
        setupConstraint()
        setupTapGestures()
        profilePhoto.layer.cornerRadius = 60
    }
    
    private func setupTapGestures() {
        
        profilePhoto.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(uploadPhoto(_:)))
        )
    
        friendsContainer.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(showFriends(_:)))
        )
        
        postContainer.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(showPosts(_:)))
        )
        
    }
    
    private func setupStackView() {
        
        [postContainer,friendsContainer,profileAccessButton].forEach {
            profileStack.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            postContainer.widthAnchor.constraint(equalTo: profileAccessButton.widthAnchor),
            friendsContainer.widthAnchor.constraint(equalTo: postContainer.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(username: String,friendsCount: Int,postsCount: Int,bio: String,profileDP: String,profileAccessibility: ProfileAccess) {
        
        userNameLabel.text = username
        friendsCountLabel.text = String(friendsCount)
        postsCountLabel.text = String(postsCount)
        bioLabel.text = bio
        isPhotoAvailable = profileDP == Constants.noDPSavingFormat ? false : true
        profilePhoto.image = AppUtility.getDisplayPicture(fileName: profileDP)
        self.profileAccessibility = profileAccessibility
        
        if self.profileAccessibility == .owner {
            setupOwnerProfile()
        } else if self.profileAccessibility == .friend {
            setupFriendProfile()
        } else if self.profileAccessibility == .requested {
            setupRequestedUserProfile()
        } else if self.profileAccessibility == .blocked {
            setupBlockedUserProfile()
        } else {
            setupUnknownUserProfile()
        }
    
        profileAccessButton.addTarget(self, action: #selector(performUserAccessibilityProcess), for: .touchUpInside)
    }
    
    @objc private func performUserAccessibilityProcess() {
        if profileAccessibility == .owner {
            editProfile()
        } else if profileAccessibility == .friend {
            unFollowUser()
            profileAccessibility = .unknown
        } else if profileAccessibility == .requested {
            cancelFriendRequest()
            profileAccessibility = .unknown
        } else {
            sendFriendRequest()
            profileAccessibility = .requested
        }
    }
    
    private func setupOwnerProfile() {
        profileAccessButton.setTitle(" Edit\nProfile", for: .normal)
    }

    private func setupFriendProfile() {
        profileAccessButton.setTitle("Unfriend", for: .normal)
    }
    
    private func setupRequestedUserProfile() {
        profileAccessButton.setTitle(" Cancel\nRequest", for: .normal)
    }

    private func setupUnknownUserProfile() {
        profileAccessButton.setTitle("Follow", for: .normal)
    }
    
    private func setupBlockedUserProfile() {
        profileAccessButton.setTitle("Blocked", for: .normal)
        profileAccessButton.isUserInteractionEnabled = false
    }

    @objc private func editProfile() {
        delegate?.editProfile()
    }
    
    @objc private func sendFriendRequest() {
        setupRequestedUserProfile()
        delegate?.sendFriendRequest()
    }
    
    @objc private func cancelFriendRequest() {
        setupUnknownUserProfile()
        delegate?.cancelFriendRequest()
    }
    
    @objc private func unFollowUser() {
        setupUnknownUserProfile()
        delegate?.unFriendAnUser()
    }
    
    @objc private func showFriends(_ sender : UITapGestureRecognizer) {
        
        if profileAccessibility == .owner || profileAccessibility == .friend {
            delegate?.getFriendsList()
        }
    }
    
    @objc private func showPosts(_ sender: UITapGestureRecognizer) {
        delegate?.showPosts()
    }
}

extension ProfileHeaderCollectionReusableView {
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = systemLayoutSizeFitting(layoutAttributes.size)
        layoutAttributes.size = size
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
    
    @objc func uploadPhoto(_ sender : UITapGestureRecognizer) {
        
        if profileAccessibility != .owner {
            return
        }

        let imagePicker = UIAlertController(title: "CHANGE DP", message: nil, preferredStyle: .actionSheet)

        imagePicker.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            self.showImagePicker(selectedSource: .camera)
        })
        imagePicker.addAction(UIAlertAction(title: "Gallery", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        })
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = AppUtility.getProfilePhotoSavingFormat(userID: loggedUserID)
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            imagePicker.addAction(UIAlertAction(title: "Remove", style: .default) { _ in
                self.profilePhoto.image = UIImage(named: "blankPhoto")
                self.delegate?.removeProfilePhoto()
                NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
                NotificationCenter.default.post(name: Constants.userDetailsEvent, object: nil)
            })
        }
        
        
        imagePicker.addAction(
            UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        )
        
        delegate?.controller().present(imagePicker, animated: true,completion: nil)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.size.width, height: 180  + userNameLabel.intrinsicContentSize.height + bioLabel.intrinsicContentSize.height + 70)
    }
}

extension ProfileHeaderCollectionReusableView {
    
    private func setupConstraint() {
    
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 10),
            profilePhoto.leadingAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.leadingAnchor),
            profilePhoto.trailingAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.trailingAnchor),
            profilePhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            profilePhoto.heightAnchor.constraint(equalToConstant: 120),
            profilePhoto.widthAnchor.constraint(equalTo: profilePhoto.heightAnchor),
            
            profileStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            profileStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            profileStack.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 10),
            profileStack.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.topAnchor.constraint(equalTo: profileStack.bottomAnchor,constant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            
            bioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 4),
            bioLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            bioLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
        ])
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
            
            let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
            
            selectedImage.saveImage(imageName: AppUtility.getProfilePhotoSavingFormat(userID: userID),
                image: selectedImage)
            
            delegate?.uploadPhoto(image: selectedImage)
            NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
            NotificationCenter.default.post(name: Constants.userDetailsEvent, object: nil)
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
