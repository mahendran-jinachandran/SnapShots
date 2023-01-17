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
    private var firstCell: CGPoint?
        
    private lazy var profileHeader: UILabel = {
        return UILabel()
    }()
    
    private lazy var moreInfo: UIButton = {
        var moreInfo = UIButton(frame: .zero)
        moreInfo.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreInfo.tintColor = UIColor(named: "appTheme")
        return moreInfo
    }()

    init(profileControls: ProfileControlsProtocols,userID: Int,isVisiting: Bool) {
        self.profileControls = profileControls
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
        
        if profileAccessibility != .blocked {
            posts = profileControls.getAllPosts(userID: userID)
        } else {
            profileUser.profile.friendsList = []
            profileUser.profile.posts = [:]
        }
        
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 1
        
        profileView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        profileView.showsVerticalScrollIndicator = false
        profileView.alwaysBounceVertical = true
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
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
        
        if isVisiting {
            setupVisitingNavigationItems()
        } else {
            setupOwnerNavigationItems()
        }
    }
    
    private func setupVisitingNavigationItems() {
        
        title = profileUser.userName
        
        if profileAccessibility == .owner || profileAccessibility == .blocked {
            return
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreInfo)
        
        let blockUser = UIAction(title: "Block User",image: UIImage(systemName: "nosign")) { _ in
            self.profileControls.blockTheUser(userID: self.userID)
            self.navigationController?.popViewController(animated: true)
        }
        
        moreInfo.showsMenuAsPrimaryAction = true
        let moreInfoMenu = UIMenu(title: "",children: [blockUser])
        moreInfo.menu = moreInfoMenu
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
        
        let bottomSheetVC = BottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .overCurrentContext
        bottomSheetVC.bottomSheetsDelegate = self
        if let rootViewController = view.window?.rootViewController {
            rootViewController.present(bottomSheetVC, animated: true)
        }
    }
    
    @objc private func uploadNewPost() {

        let newPostControls = NewPostControls()
        let newPostVC = NewPostVC(newPostControls: newPostControls)
        let postNavigation = UINavigationController(rootViewController: newPostVC)
        postNavigation.modalPresentationStyle = .fullScreen

        present(postNavigation, animated: true)

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
            
            footerView.configure(profileAccessibility: profileAccessibility)
            
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
        NotificationCenter.default.addObserver(self, selector: #selector(createPost(_:)), name: Constants.createPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletePost(_:)), name: Constants.deletePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePost(_:)), name: Constants.updatePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: Constants.updateUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFriendPost(_:)), name: Constants.addFriendPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeFriend(_:)), name: Constants.blockUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFriend(_:)), name: Constants.unblockingUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeFriend), name: Constants.removeFriendPostEvent, object: nil)
    }
    
    
    @objc private func removeFriend(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
            
            profileUser.profile.friendsList.remove(data)
            
            let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
            
            headerView.setData(
                username: profileUser.userName,
                friendsCount: profileUser.profile.friendsList.count,
                postsCount: posts.count,
                bio: profileUser.profile.bio,
                profileDP: profileUser.profile.photo,
                profileAccessibility: profileAccessibility
            )
            
        }
    }
    
    @objc private func addFriend(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
        
            let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
            
            if !(profileControls.isUserFriends(userID: data, loggedUserID: loggedUserID)){
                return
            }
            
            profileUser.profile.friendsList.insert(data)
            
            let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
            
            headerView.setData(
                username: profileUser.userName,
                friendsCount: profileUser.profile.friendsList.count,
                postsCount: posts.count,
                bio: profileUser.profile.bio,
                profileDP: profileUser.profile.photo,
                profileAccessibility: profileAccessibility
            )
            
        }
    }

    @objc private func addFriendPost(_ notification: NSNotification) {
        
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [FeedsDetails] {
        
            let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
            print(profileControls.isUserFriends(userID: data[0].userID, loggedUserID: loggedUserID))
            
            if data.isEmpty || !(profileControls.isUserFriends(userID: data[0].userID, loggedUserID: loggedUserID)){
                
                return
            }
            
            profileUser.profile.friendsList.insert(data[0].userID)
            
            let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
            
            headerView.setData(
                username: profileUser.userName,
                friendsCount: profileUser.profile.friendsList.count,
                postsCount: posts.count,
                bio: profileUser.profile.bio,
                profileDP: profileUser.profile.photo,
                profileAccessibility: profileAccessibility
            )
            
        }
    }
    
    @objc private func updateUser(_ notification: NSNotification) {
     
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? User {
            
            profileUser.userName = data.userName
            profileUser.profile.bio = data.profile.bio
            profileUser.profile.photo = AppUtility.getProfilePhotoSavingFormat(userID: data.userID)
                
            let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
            
            headerView.setData(
                username: profileUser.userName,
                friendsCount: profileUser.profile.friendsList.count,
                postsCount: posts.count,
                bio: profileUser.profile.bio,
                profileDP: profileUser.profile.photo,
                profileAccessibility: profileAccessibility
            )
            
            setupOwnerNavigationItems()
        }
    }
    
    
    @objc private func updatePost(_ notification: NSNotification) {
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? FeedsDetails {
            
            var isPostArchivingChanged: Bool = false
            
            for post in posts where post.postID == data.postDetails.postID {
                isPostArchivingChanged = post.isArchived != data.postDetails.isArchived
            }
            
            if isPostArchivingChanged || posts.isEmpty {
                if data.postDetails.isArchived {
                    for (index,post) in posts.enumerated() where post.postID == data.postDetails.postID {
                                        
                        posts.remove(at: index)
                        profileView.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
                        profileView.deleteItems(at: [IndexPath(row: index, section: 0)])
                        
                        let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
                        
                        headerView.setData(
                            username: profileUser.userName,
                            friendsCount: profileUser.profile.friendsList.count,
                            postsCount: posts.count,
                            bio: profileUser.profile.bio,
                            profileDP: profileUser.profile.photo,
                            profileAccessibility: profileAccessibility
                        )
                    }
                    
                } else {
                    
                    posts.insert(data.postDetails, at: 0)
                    profileView.insertItems(at: [IndexPath(row: 0, section: 0)])
                    
                    let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
                    
                    headerView.setData(
                        username: profileUser.userName,
                        friendsCount: profileUser.profile.friendsList.count,
                        postsCount: posts.count,
                        bio: profileUser.profile.bio,
                        profileDP: profileUser.profile.photo,
                        profileAccessibility: profileAccessibility
                    )
                }
            }
        }
    }
    
    @objc private func createPost(_ notification: NSNotification) {
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? FeedsDetails {
            
            posts.insert(data.postDetails, at: 0)
            profileView.insertItems(at: [IndexPath(row: 0, section: 0)])
            
            let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
            
            headerView.setData(
                username: profileUser.userName,
                friendsCount: profileUser.profile.friendsList.count,
                postsCount: posts.count,
                bio: profileUser.profile.bio,
                profileDP: profileUser.profile.photo,
                profileAccessibility: profileAccessibility
            )
        }
    }
    
    @objc private func deletePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? ListCollectionDetails {
            
            for (index,post) in posts.enumerated() where post.postID == data.postID {
                                
                posts.remove(at: index)
                profileView.scrollToItem(at: IndexPath(row: index, section: 0), at: .top, animated: true)
                profileView.deleteItems(at: [IndexPath(row: index, section: 0)])
                
                let headerView = profileView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at:  IndexPath(item: 0, section: 0)) as! ProfileHeaderCollectionReusableView
                
                headerView.setData(
                    username: profileUser.userName,
                    friendsCount: profileUser.profile.friendsList.count,
                    postsCount: posts.count,
                    bio: profileUser.profile.bio,
                    profileDP: profileUser.profile.photo,
                    profileAccessibility: profileAccessibility
                )
            }
        }
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
  
            NotificationCenter.default.post(name: Constants.removeFriendPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: userID])
            
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
    
    func showPosts() {
        
       let ip = IndexPath(row: 0, section: 0)
        if profileView.indexPathsForVisibleItems.contains(ip)
        {
            profileView.scrollToItem(at: ip, at: .top, animated: true)
        }
    }
}

// MARK: CHECK FOR ALTERNATIVE DIDSELECTROW AT
extension ProfileVC: CustomCollectionViewCellDelegate {
    
    func openPost(sender: CustomCollectionViewCell) {
        
        let indexPath = profileView.indexPath(for: sender)!
        
        let postPicture = AppUtility.getPostPicture(
            userID: userID,
            postID: posts[indexPath.row].postID)
        
        let isSaved = profileControls.isPostSaved(postUserID: userID, postID: posts[indexPath.row].postID)
        
        let postControls = PostControls()
        let postVC = PostVC(postControls: postControls,userID: userID,postImage: postPicture, postDetails: posts[indexPath.row],isSaved: isSaved)
    
        navigationController?.pushViewController(postVC,animated: true)
    }
}

extension ProfileVC: BottomSheetsVCDelegate {
    func presentANewViewController(VCName: BottomSheetEntity) {
        
        switch VCName {
            case .settings:
                navigationController?.pushViewController(SettingsViewController(), animated: true)
            
            case .archives:
                let listCollectionVC = ListCollectionVC(listCollectionControls: ListCollectionControls(),listCollectionEntity: .archive)
                navigationController?.pushViewController(listCollectionVC, animated: true)
            
            case .blockedUsers:
                let listTableVC = ListTableVC(listTableControls: ListTableControls())
                navigationController?.pushViewController(listTableVC, animated: true)
            
            case .saved:
                let listCollectionVC = ListCollectionVC(listCollectionControls: ListCollectionControls(), listCollectionEntity: .savedCollection)
                navigationController?.pushViewController(listCollectionVC, animated: true)
        }
    }
}


