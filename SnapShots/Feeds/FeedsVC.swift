//
//  FeedsViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit

class FeedsVC: UIViewController {
    
    private var feedPosts: [FeedsDetails] = []
    
    private var feedsControls: FeedsControls!
    func setController(_ feedsControls: FeedsControls) {
        self.feedsControls = feedsControls
    }
    
    private lazy var feedsTable: UITableView = {
        let feedsTable = UITableView(frame: .zero)
        feedsTable.translatesAutoresizingMaskIntoConstraints = false
       return feedsTable
    }()
    
    private lazy var noPostsNotify: UIView = {
        let noPostsNotify = UIView()
        noPostsNotify.backgroundColor = .red
        return noPostsNotify
    }()
    
    private lazy var noPostsLabel: UILabel = {
       let noPostsLabel = UILabel()
        noPostsLabel.text = "No Feeds"
        noPostsLabel.textColor = .gray
        noPostsLabel.textAlignment = .center
        return noPostsLabel
    }()
    
    private lazy var friendsMenuButton: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        button.titleLabel?.font = UIFont(name: "Billabong", size: 30)
        button.setTitle("Snapshots ", for: .normal)
        button.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        button.setImage(UIImage(systemName: "chevron.down")!, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.tintColor = UIColor(named: "appTheme")!
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()
        setupFeedsTable()
        setConstraints()
        setupNotificationSubscription()
    }
    
    private func setupFeedsTable() {
        
        feedsTable.register(FeedsCustomCell.self, forCellReuseIdentifier: FeedsCustomCell.identifier)
        feedsTable.separatorStyle = .none
        feedsTable.delegate = self
        feedsTable.dataSource = self
        feedsTable.estimatedRowHeight = 300
        feedsTable.rowHeight = UITableView.automaticDimension
        
        feedsTable.backgroundView = noPostsLabel
        getEntireFeeds()
    }
    
    private func setNavigationItems() {
        view.backgroundColor = .systemBackground
        
        // LEFT BAR BUTTON ITEM
        let friendsAction = UIAction(
          title: "Friends",
          image: UIImage(systemName: "person.3.fill")) { _ in
              
              let friendsControls = FriendsControls()
              let userID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
              let friendsListVC = FriendsListVC(userID: userID, friendsControls: friendsControls)
              
              self.navigationController?.pushViewController(friendsListVC, animated: true)
        }
        
        friendsMenuButton.menu = UIMenu(title: "", image: nil, children: [friendsAction])
       
        let barButton = UIBarButtonItem(customView: friendsMenuButton)
        navigationItem.leftBarButtonItem = barButton
        
        // RIGHT BAR BUTTON ITEM
        let addPost = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(uploadNewPost))
        addPost.tintColor = UIColor(named: "appTheme")!
        navigationItem.rightBarButtonItem = addPost
        
        // BACK BUTTON
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "appTheme")!
    }
    

    
    private func setupNotificationSubscription() {
        NotificationCenter.default.addObserver(self, selector: #selector(getEntireFeeds), name: Constants.publishPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getEntireFeeds), name: Constants.userDetailsEvent, object: nil)
    }
    
    @objc private func getEntireFeeds() {
        feedPosts = feedsControls.getAllPosts()
        if feedPosts.count > 0 {
            feedsTable.backgroundView?.alpha = 0.0
        } else {
            feedsTable.backgroundView?.alpha = 1.0
        }
        feedsTable.reloadData()
    }

    private func setConstraints() {
        view.addSubview(feedsTable)
        NSLayoutConstraint.activate([
            feedsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            feedsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func uploadNewPost() {
        
        let newPostControls = NewPostControls()
        let newPostVC = NewPostVC(newPostControls: newPostControls)
        let postNavigation = UINavigationController(rootViewController: newPostVC)
        postNavigation.modalPresentationStyle = .fullScreen

        present(postNavigation, animated: true)
    }
}

extension FeedsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postPhoto = AppUtility.getPostPicture(
            userID: feedPosts[indexPath.row].userID,
            postID: feedPosts[indexPath.row].postDetails.postID)
        
        let postControls = PostControls()
        let postVC = PostVC(
            postControls: postControls,
            userID: feedPosts[indexPath.row].userID,
            postImage: postPhoto,
            postDetails: feedPosts[indexPath.row].postDetails)
        
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: FeedsCustomCell.identifier, for: indexPath) as! FeedsCustomCell
        
        particularCell.delegate = self
        
        let profilePhoto = AppUtility.getDisplayPicture(userID: feedPosts[indexPath.row].userID)
        let postPhoto = AppUtility.getPostPicture(
            userID: feedPosts[indexPath.row].userID,
            postID: feedPosts[indexPath.row].postDetails.postID)
        
        particularCell.configure(
            profilePhoto: profilePhoto,
            username: "\(feedPosts[indexPath.row].userName)",
            postPhoto: postPhoto,
            postCaption: feedPosts[indexPath.row].postDetails.caption,
            isAlreadyLiked: feedsControls.isAlreadyLikedThePost(postDetails: feedPosts[indexPath.row]),
            likedUsersCount: feedsControls.getAllLikedUsers(postUserID: feedPosts[indexPath.row].userID, postID: feedPosts[indexPath.row].postDetails.postID),
            commentedUsersCount: feedsControls.getAllComments(postUserID: feedPosts[indexPath.row].userID, postID: feedPosts[indexPath.row].postDetails.postID),
            postCreatedTime: feedPosts[indexPath.row].postDetails.postCreatedDate,
            isDeletionAllowed: feedsControls.isDeletionAllowed(userID: feedPosts[indexPath.row].userID)
        )
        
        return particularCell
    }
}

extension FeedsVC: FeedsCustomCellDelegate {

    func controller() -> FeedsVC {
        return self
    }
    
    func likeThePost(sender: FeedsCustomCell) {
        
        let indexPath = feedsTable.indexPath(for: sender)!
        let postUserID = feedPosts[indexPath.row].userID
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        _ = feedsControls.addLikeToThePost(postUserID: postUserID, postID: postID) 
    }
    
    func unLikeThePost(sender: FeedsCustomCell) {
        
        let indexPath = feedsTable.indexPath(for: sender)!
        let postUserID = feedPosts[indexPath.row].userID
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        _ = feedsControls.removeLikeFromThePost(postUserID: postUserID, postID: postID)
    }
    
    func showLikes(sender: FeedsCustomCell) {
        let indexPath = feedsTable.indexPath(for: sender)!
        let postUserID = feedPosts[indexPath.row].userID
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        let LikesControls = LikesControls()
        let likesVC = LikesVC(likesControls: LikesControls, postUserID: postUserID, postID: postID)
        
        navigationController?.pushViewController(likesVC, animated: true)
    }
    
    func showComments(sender: FeedsCustomCell) {
        let indexPath = feedsTable.indexPath(for: sender)!
        let postUserID = feedPosts[indexPath.row].userID
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        let commentControls = CommentsControls()
        let commentsVC = CommentsVC(commentsControls: commentControls, postUserID: postUserID, postID: postID)
        
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func deletePost(sender: FeedsCustomCell) {
        let indexPath = feedsTable.indexPath(for: sender)!
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        _ = feedsControls.deletePost(postID: postID)
    }
    
    func goToProfile(sender: FeedsCustomCell) {
        
        let indexPath = feedsTable.indexPath(for: sender)!
        
        let profileControls = ProfileControls()
        let profileVC = ProfileVC(
            profileControls: profileControls,
            userID: feedPosts[indexPath.row].userID,
            isVisiting: true)
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
