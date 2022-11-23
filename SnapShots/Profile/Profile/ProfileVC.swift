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
    private var posts: [UIImage] = []
    
    var profileHeader: UILabel = {
        var profileTitle = UILabel()
        profileTitle.attributedText = NSAttributedString(string: "Mahendran",attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ])
        return profileTitle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        layout.minimumLineSpacing = 1
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
        
        setNavigationItems()
        setProfileConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        if Int(profileControls.getNumberOfPosts(userID: userID))! > 0 {
            posts = profileControls.getAllPosts()
            profileView.reloadData()
        } else {
            print("NOT AVAI")
        }
    }
        
    func setProfileConstraints() {
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileHeader)
        
        let hamburgerMenu = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(openSettings))
        hamburgerMenu.tintColor = UIColor(named: "mainPage")!
        
        let addPost = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(uploadNewPost))
        addPost.tintColor = UIColor(named: "mainPage")!
     
        navigationItem.rightBarButtonItems = [ hamburgerMenu,addPost]
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
    
    var headerView: ProfileHeaderCollectionReusableView!
}

extension ProfileVC: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
            for: indexPath) as? ProfileHeaderCollectionReusableView
        
        guard let headerView else {
            return UICollectionViewCell()
        }
        
        headerView.delegate = self
        
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        profileHeader.text = profileControls.getUsername(userID: userID)
        
        headerView.setData(
            username: profileHeader.text!,
            friendsCount: profileControls.getNumberOfFriends(userID: userID),
            postsCount: profileControls.getNumberOfPosts(userID: userID),
            bio: profileControls.getProfileBio(userID: userID)
        )
        
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let userID = UserDefaults.standard.integer(forKey: "CurrentLoggedUser")
        return Int(profileControls.getNumberOfPosts(userID: userID))!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.myImageView.image = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: (collectionView.frame.width / 3) - 1,
                      height: ( collectionView.frame.width / 3) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: 300, height: 300)
    }
}

extension ProfileVC: ProfileHeaderCollectionReusableViewDelegate {
    func controller() -> ProfileVC {
        return self
    }
}
