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
            print("Blocked user")
            self.profileControls.blockTheUser(userID: self.userID)
            NotificationCenter.default.post(name: Constants.blockEvent, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        
        let addToFavourite = UIAction(title: "Add to favourites", image: UIImage(systemName: "star")) { _ in
            print("Added to favourites")
        }
        
        moreInfo.showsMenuAsPrimaryAction = true
        let moreInfoMenu = UIMenu(title: "",children: [blockUser,addToFavourite])
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostSection), name: Constants.publishPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserDetails), name: Constants.userDetailsEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserDetails), name: Constants.blockEvent, object: nil)
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
        
        let postControls = PostControls()
        let postVC = PostVC(postControls: postControls,userID: userID,postImage: postPicture, postDetails: posts[indexPath.row])
    
        navigationController?.pushViewController(postVC,animated: true)
    }
}

extension ProfileVC: BottomSheetsVCDelegate {
    func presentANewViewController(VCName: BottomSheetEntity) {
        
        switch VCName {
            case .settings:
                print("Settings")
                navigationController?.pushViewController(SettingsViewController(), animated: true)
            case .archives:
                print("Archive")
            case .blockedUsers:
    
                let listTableVC = ListTableVC(listTableControls: ListTableControls())
                navigationController?.pushViewController(listTableVC, animated: true)
            
            case .saved:
                print("Saved")
        }
    }
}


