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
    public var profileControls: ProfileControls!
    private var posts: [(postImage: UIImage,postDetails: Post)] = []
    private var user: User!
    private var userID: Int
    private var profileAccessibility: ProfileAccess!
    
    var profileHeader: UILabel = {
        return UILabel()
    }()
    
    // MARK: FIND SOME OTHER WAY (REDUNDANCY B/W userID and loggedUser)
    init(userID: Int) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileAccessibility = profileControls.getProfileAccessibility(userID: userID)
        self.user = profileControls.getUserDetails(userID: userID)
        setupSearchTable()
        
        setNavigationItems()

        setProfileConstraints()
        profileHeader.attributedText = NSAttributedString(string: user.userName,attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        posts = profileControls.getAllPosts()
        if posts.count > 0 {
            profileView.reloadData()
        } else {
            posts = []
            profileView.reloadData()
        }
    }
    
    func setupSearchTable() {
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
      
        profileView.dataSource = self
        profileView.delegate = self
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileView)
    }
    
    func setNavigationItems() {
        
        let profileAccess = profileAccessibility!
        switch profileAccess {
            case .owner:
                setupOwnerNavigationItems()
            case .friend:
                setupFriendsNavigationItems()
                fallthrough
            case .acquaintance:
                setupFriendsNavigationItems()
        }
        
        navigationController?.navigationBar.tintColor = UIColor(named: "mainPage")
    }
    
    func setupOwnerNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileHeader)
        let hamburgerMenu = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(openSettings))
        hamburgerMenu.tintColor = UIColor(named: "mainPage")!
        
        let addPost = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(uploadNewPost))
        addPost.tintColor = UIColor(named: "mainPage")!
     
        navigationItem.rightBarButtonItems = [ hamburgerMenu,addPost]
    }
    
    func setupFriendsNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBack))
        title = user.userName
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: false)
    }
        
    func setProfileConstraints() {
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func openSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: false)
    }
    
    @objc func uploadNewPost() {
        
        let newPostVC = NewPostVC()
        let newPostControls = NewPostControls()
        
        newPostVC.newPostControls = newPostControls
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
      
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
            for: indexPath) as! ProfileHeaderCollectionReusableView
        
        headerView.delegate = self
        
        headerView.setData(
            username: user.userName,
            friendsCount: user.profile.friendsList.count,
            postsCount: user.profile.posts.count,
            bio: user.profile.bio,
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
    
        return CGSize(width: (collectionView.frame.width / 3) - 10,
                      height: ( collectionView.frame.width / 3) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: 500, height: 320)
    }
    
    @objc func openPost(_ sender: UITapGestureRecognizer) {

        navigationController?.pushViewController(
            PostVC(
                postImage: posts[sender.view!.tag].postImage,
                postDetails: posts[sender.view!.tag].postDetails),
            animated: false)
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
            print("FRIEND REQUEST SENT")
        } else {
            print("Couldn't send friend request")
        }
    }
    
    @objc func cancelFriendRequest() {
    }
}
