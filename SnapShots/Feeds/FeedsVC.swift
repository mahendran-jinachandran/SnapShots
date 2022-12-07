//
//  FeedsViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/11/22.
//

import UIKit

class FeedsVC: UIViewController {
    
    private var feedPosts: [(userID:Int,userName: String,userDP: UIImage,postDetails:Post,postPhoto: UIImage)] = []
    
    private var feedsControls: FeedsControls!
    func setController(_ feedsControls: FeedsControls) {
        self.feedsControls = feedsControls
    }
    
    private let feedsTable: UITableView = {
        let feedsTable = UITableView(frame: .zero)
        feedsTable.translatesAutoresizingMaskIntoConstraints = false
        feedsTable.register(FeedsCustomCell.self, forCellReuseIdentifier: FeedsCustomCell.identifier)
        feedsTable.bounces = false
        feedsTable.separatorStyle = .none
       return feedsTable
    }()
    
    private var noPostsNotify: UILabel = {
        let noRequestsNotify = UILabel()
        noRequestsNotify.text = "No Feeds"
        noRequestsNotify.textColor = .gray
        noRequestsNotify.translatesAutoresizingMaskIntoConstraints = false
        return noRequestsNotify
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()
        setupFeedsTable()
        setupNotificationSubscription()
    }
    
    func setupFeedsTable() {
        feedsTable.delegate = self
        feedsTable.dataSource = self
        feedsTable.estimatedRowHeight = 300
        feedsTable.rowHeight = UITableView.automaticDimension
        
        feedPosts = feedsControls.getAllPosts()
        if feedPosts.count > 0 {
            setConstraints()
        } else {
            setNoFeedsConstraints()
        }
    }
    
    func setNavigationItems() {
        let friendsAction = UIAction(
          title: "Friends",
          image: UIImage(systemName: "person.3.fill")) { _ in
        }
        
        let button  = UIButton(type: .custom)
        button.showsMenuAsPrimaryAction = true
        button.titleLabel?.font = UIFont(name: "Billabong", size: 30)
        button.setTitle("Snapshots ", for: .normal)
        button.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        button.setImage(UIImage(systemName: "chevron.down")!, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.tintColor = UIColor(named: "appTheme")!
        button.menu = UIMenu(title: "", image: nil, children: [friendsAction])
        
        let barButton =  UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func setupNotificationSubscription() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPostSection), name: Constants.publishPostEvent, object: nil)
    }
    
    @objc func refreshPostSection() {
        feedPosts = feedsControls.getAllPosts()
        if feedPosts.count > 0 {
            setConstraints()
        } else {
            setNoFeedsConstraints()
        }
        feedsTable.reloadData()
    }

    func setConstraints() {
        view.addSubview(feedsTable)
        NSLayoutConstraint.activate([
            feedsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8),
            feedsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setNoFeedsConstraints() {
        view.addSubview(noPostsNotify)
        NSLayoutConstraint.activate([
            noPostsNotify.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noPostsNotify.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension FeedsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let particularCell = tableView.dequeueReusableCell(withIdentifier: FeedsCustomCell.identifier, for: indexPath) as! FeedsCustomCell
        
        particularCell.delegate = self
        
        print(FeedsControls().isAlreadyLikedThePost(postDetails: feedPosts[indexPath.row]))
        particularCell.configure(
            profilePhoto: feedPosts[indexPath.row].userDP,
            username: "\(feedPosts[indexPath.row].userName)",
            postPhoto: feedPosts[indexPath.row].postPhoto,
            postCaption: feedPosts[indexPath.row].postDetails.caption,
            isAlreadyLiked: feedsControls.isAlreadyLikedThePost(postDetails: feedPosts[indexPath.row])
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
        
        if feedsControls.addLikeToThePost(postUserID: postUserID, postID: postID) {
            print("Liked")
        } else {
            print("Could not like")
        }
    }
    
    func unLikeThePost(sender: FeedsCustomCell) {
        
        let indexPath = feedsTable.indexPath(for: sender)!
        let postUserID = feedPosts[indexPath.row].userID
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        if feedsControls.removeLikeFromThePost(postUserID: postUserID, postID: postID) {
            print("Unliked")
        } else {
            print("Could not unlike")
        }
    }
    
    func showLikes(sender: FeedsCustomCell) {
        let indexPath = feedsTable.indexPath(for: sender)!
        let postUserID = feedPosts[indexPath.row].userID
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        let LikesControls = LikesControls()
        let likesVC = LikesVC(likesControls: LikesControls, postUserID: postUserID, postID: postID)
        
        navigationController?.present(likesVC, animated: true)
    }
    
    func showComments(sender: FeedsCustomCell) {
        let indexPath = feedsTable.indexPath(for: sender)!
        let postUserID = feedPosts[indexPath.row].userID
        let postID = feedPosts[indexPath.row].postDetails.postID
        
        let commentControls = CommentsControls()
        let commentsVC = CommentsVC(commentsControls: commentControls, postUserID: postUserID, postID: postID)
        
        navigationController?.pushViewController(commentsVC, animated: true)
    }
}
