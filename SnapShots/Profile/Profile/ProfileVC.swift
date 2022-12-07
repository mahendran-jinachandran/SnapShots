//
//  ProfileViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit

class ProfileVC: UIViewController {
    
    private var profileView: UICollectionView!
    private var layout = UICollectionViewFlowLayout()
    private var profileControls: ProfileControlsProtocols!
    private var posts: [(postImage: UIImage,postDetails: Post)] = []
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
        
        navigationItem.title = ""
        profileAccessibility = profileControls.getProfileAccessibility(userID: userID)
        self.profileUser = profileControls.getUserDetails(userID: userID)
        
        setupProfileView()
        setNavigationItems()
        setProfileConstraints()
        setupNotificationSubscription()
    }
    
    private func setupProfileView() {
        
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
        
        if posts.isEmpty || profileAccessibility == .requested || profileAccessibility == .unknown {
            profileView.register(
                ProfileFooterCollectionResuableView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: ProfileFooterCollectionResuableView.identifier)
        }
      
        profileView.dataSource = self
        profileView.delegate = self
        profileView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setNavigationItems() {
        if isVisiting {
            title = profileUser.userName
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBack))
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
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: false)
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
     
        navigationController?.pushViewController(newPostVC, animated: false)
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
            profileDP: profileControls.getProfileDP(),
            profileAccessibility: profileAccessibility
        )
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.postImage.image = posts[indexPath.item].postImage
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(openPost(_:)))
        cell.postImage.addGestureRecognizer(imagePicker)
        cell.tag = indexPath.item
        
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

        return CGSize(width: 500, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if  posts.isEmpty || profileAccessibility == .requested || profileAccessibility == .unknown   {
            return CGSize(width: 500, height: 320)
        }
        
        return  CGSize(width: 0, height: 0)
    }
    
    @objc func openPost(_ sender: UITapGestureRecognizer) {

        navigationController?.pushViewController(
            PostVC(
                postImage: posts[sender.view!.tag].postImage,
                postDetails: posts[sender.view!.tag].postDetails),
            animated: false)
    }
    
    func setupNotificationSubscription() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostSection), name: Constants.publishPostEvent, object: nil)
    }
    
    @objc func refreshPostSection() {
        posts = profileControls.getAllPosts(userID: userID)
        profileView.reloadData()
    }
}

extension ProfileVC: ProfileHeaderCollectionReusableViewDelegate {
    func controller() -> ProfileVC {
        return self
    }
    
    @objc func getFriendsList() {
        self.navigationController?.pushViewController(FriendsListVC(), animated: false)
    }
    
    @objc func sendFriendRequest() {
        if profileControls.sendFriendRequest(requestingUser: userID) {
            // MARK: TOAST SEND FRIEND REQUEST
            print("REQUEST SENT")
        } else {
            // MARK: TOAST COULDN'T SEND REQUEST
            print("COULDN'T SEND REQUEST")
        }
        
        profileView.reloadData()
    }
    
    @objc func cancelFriendRequest() {
    }
    
    func uploadPhoto(image: UIImage) {
        profileControls.updateProfilePhoto(profilePhoto: image)
    }
}
