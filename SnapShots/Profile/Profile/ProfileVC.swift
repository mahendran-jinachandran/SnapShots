//
//  ProfileViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit

class ProfileVC: UIViewController{
    
    private var profileView: UICollectionView!
    private var layout = UICollectionViewFlowLayout()
    private var profileControls: ProfileControlsProtocols!
    private var posts: [Post] = []
    private var profileUser: User!
    private var userID: Int!
    private var profileAccessibility: ProfileAccess!
    private var isVisiting: Bool!
    
    public func setController(_ profileControls: ProfileControlsProtocols) {
        self.profileControls = profileControls
    }
    
    private lazy var profileHeader: UILabel = {
        return UILabel()
    }()

    init(userID: Int,isVisiting: Bool) {
        self.userID = userID
        self.isVisiting = isVisiting
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfileView()
        setNavigationItems()
        setProfileConstraints()
        setupNotificationSubscription()
    }
    
    private func setupProfileView() {
        
        
        profileAccessibility = profileControls.getProfileAccessibility(userID: userID)
        self.profileUser = profileControls.getUserDetails(userID: userID)
        posts = profileControls.getAllPosts(userID: userID)
        
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 1
        
        profileView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        profileView.showsVerticalScrollIndicator = false
        
        profileView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        profileView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        
        
        profileView.register(
            ProfileFooterCollectionResuableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ProfileFooterCollectionResuableView.identifier)
        
        profileView.dataSource = self
        profileView.delegate = self
        profileView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setNavigationItems() {
        navigationItem.title = ""
        view.backgroundColor = .systemBackground
        
        if isVisiting {
            title = profileUser.userName
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        } else {
            setupOwnerNavigationItems()
        }
        
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
    }
    
    private func setupOwnerNavigationItems() {
        
        profileHeader.attributedText = NSAttributedString(string: profileUser.userName,attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileHeader)
        
        let hamburgerMenu = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(openSettings))
        hamburgerMenu.tintColor = UIColor(named: "appTheme")!
        
        let addPost = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(uploadNewPost))
        addPost.tintColor = UIColor(named: "appTheme")!
     
        navigationItem.rightBarButtonItems = [ hamburgerMenu,addPost]
    }
        
    private func setProfileConstraints() {
        
        view.addSubview(profileView)
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func openSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc private func uploadNewPost() {
        
        let newPostControls = NewPostControls()
        let newPostVC = NewPostVC(newPostControls: newPostControls)
     
        navigationController?.pushViewController(newPostVC, animated: true)
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
    
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileFooterCollectionResuableView.identifier, for: indexPath) as! ProfileFooterCollectionResuableView
            
            if profileAccessibility == .friend || profileAccessibility == .owner {
                footerView.configure(isFriend: true)
            } else {
                footerView.configure(isFriend: false)
            }
            
            return footerView
        }
      
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
            for: indexPath) as! ProfileHeaderCollectionReusableView
        
        headerView.delegate = self
        headerView.setData(
            username: profileUser.userName,
            friendsCount: profileUser.profile.friendsList.count,
            postsCount: posts.count,
            bio: profileUser.profile.bio,
            profileDP: profileUser.profile.photo,
            profileAccessibility: profileAccessibility
        )
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        
        let postPicture = AppUtility.getPostPicture(
            userID: userID,
            postID: posts[indexPath.row].postID)
        
        cell.delegate = self
        cell.configure(
            postImage: postPicture)

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if profileAccessibility == .requested || profileAccessibility == .unknown  {
            return CGSize(width: 0,height: 0)
        }
        
        return CGSize(width: (collectionView.frame.width / 3) - 10,
                      height: ( collectionView.frame.width / 3) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.intrinsicContentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if posts.isEmpty || profileAccessibility == .requested || profileAccessibility == .unknown   {
            return CGSize(width: 500, height: 320)
        }
        
        return  CGSize(width: 0, height: 0)
    }

    func setupNotificationSubscription() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostSection), name: Constants.publishPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserDetails), name: Constants.userDetailsEvent, object: nil)
    }
    
    @objc func refreshPostSection() {
        posts = profileControls.getAllPosts(userID: userID)
        profileView.reloadData()
    }
    
    @objc func refreshUserDetails() {
        self.profileUser = profileControls.getUserDetails(userID: userID)
        profileHeader.attributedText = NSAttributedString(string: profileUser.userName,attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        profileView.reloadData()
    }
}

extension ProfileVC: ProfileHeaderCollectionReusableViewDelegate {
    func controller() -> ProfileVC {
        return self
    }
    
    func editProfile() {
        let editProfileControls = EditProfileControls()
        let editProfileVC = EditProfileVC(editProfileControls: editProfileControls, userID: userID, username: profileUser.userName, bio: profileUser.profile.bio)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc func getFriendsList() {
        
        let friendsControls = FriendsControls()
        let friendsListVC = FriendsListVC(userID: userID, friendsControls: friendsControls)
        
        self.navigationController?.pushViewController(friendsListVC, animated: true)
    }
    
    func sendFriendRequest() {
        if !profileControls.sendFriendRequest(profileRequestedUser: userID) {
            showToast(message: Constants.toastFailureStatus)
        }
    }
    
    func cancelFriendRequest() {
        if !profileControls.cancelFriendRequest(profileRequestedUser: userID) {
            showToast(message: Constants.toastFailureStatus)
        }
    }
    
    func unFriendAnUser() {
        if profileControls.removeFrined(profileRequestedUser: userID) {
            
            NotificationCenter.default.post(name: Constants.userDetailsEvent, object: nil)
            posts = []
            profileAccessibility = profileControls.getProfileAccessibility(userID: userID)
            
            profileAccessibility = .unknown
            profileView.reloadData()

        } else {
            showToast(message: Constants.toastFailureStatus)
        }
    }
    
    func uploadPhoto(image: UIImage) {
        if profileControls.updateProfilePhoto(profilePhoto: image) {
            showToast(message: "DP Updated")
        } else {
            showToast(message: Constants.toastFailureStatus)
        }
    }
    
    func removeProfilePhoto() {
        if profileControls.removeProfilePhoto() {
            showToast(message: "DP Removed")
        } else {
            showToast(message: Constants.toastFailureStatus)
        }
    }
}

extension ProfileVC: CustomCollectionViewCellDelegate {
    
    func openPost(sender: CustomCollectionViewCell) {
        
        let indexPath = profileView.indexPath(for: sender)!
        
        let postPicture = AppUtility.getPostPicture(
            userID: userID,
            postID: posts[indexPath.row].postID)
        
        let postControls = PostControls()
        let postVC = PostVC(postControls: postControls,userID: userID,postImage: postPicture, postDetails: posts[indexPath.row])
    
        navigationController?.pushViewController(postVC,animated: true)
    }
}


