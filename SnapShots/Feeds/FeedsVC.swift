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
        feedsTable.showsVerticalScrollIndicator = false
        feedsTable.showsHorizontalScrollIndicator = false
        
        feedsTable.backgroundView = noPostsLabel
        feedPosts = feedsControls.getAllPosts()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(createPost(_:)), name: Constants.createPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletePost(_:)), name: Constants.deletePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePost(_:)), name: Constants.updatePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likePost(_:)), name: Constants.likePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unlikePost(_:)), name: Constants.unlikePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(insertComment(_:)), name: Constants.insertCommentPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteComment(_:)), name: Constants.deleteCommentPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: Constants.updateUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFriendPost(_:)), name: Constants.addFriendPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeFriendsPost), name: Constants.removeFriendPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeFriendsPost(_:)), name: Constants.blockUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addPosts(_:)), name: Constants.unblockingUserEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(savePost(_:)), name: Constants.savingPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unSavePost(_:)), name: Constants.unsavingPostEvent, object: nil)
    }
    
    @objc private func savePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? ListCollectionDetails {
            
            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == data.userID && feedPost.postDetails.postID == data.postID {
                
                feedPosts[index].isSaved = true
                
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                feedsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                
            }
        }
    }
    
    @objc private func unSavePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? ListCollectionDetails {
            
            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == data.userID && feedPost.postDetails.postID == data.postID {
                
                feedPosts[index].isSaved = false
                
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                feedsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                
            }
        }
    }
    
    @objc private func addFriendPost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [FeedsDetails] {
            for post in data {
                feedPosts.insert(post, at: 0)
                feedsTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            }
        }
    }
    
    @objc private func addPosts(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
            
            let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
            
            if !(feedsControls.isUserFriends(userID: data, loggedUserID: loggedUserID)){
                return
            }
            
            for feedPost in feedsControls.getAllUserPosts(userID: data) {
                
                feedPosts.insert(feedPost, at: 0)
                feedsTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            }
        }
    }
    
    @objc private func removeFriendsPost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
    
            var index = 0
            for post in feedPosts {
                
                if !(post.userID == data) {
                   index = index + 1
                   continue
                }
                
                feedPosts.remove(at: index)
                
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                feedsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                shouldBackgroundBeChanged()
            }
        }
    }
    
    @objc private func updateUser(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? User {
            
            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == data.userID {
            
                feedPosts[index].userName = data.userName
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                feedsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    @objc private func insertComment(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [Int:[String]] {
            
            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == Int(data[1]![1])! && feedPost.postDetails.postID == Int(data[1]![2])! {
                
                feedPost.postDetails.comments.append(CommentDetails(
                    commentID: Int(data[1]![0])!,
                    username: feedsControls.getUsername(userID: Int(data[1]![4])!),
                    comment: data[1]![3],
                    commentUserID: Int(data[1]![4])!)
                )
                
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                feedsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    @objc private func deleteComment(_ notification: NSNotification) {
    
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
            for (mainIndex,feedPost) in feedPosts.enumerated() {
                for (index,comment) in feedPost.postDetails.comments.enumerated() where comment.commentID == data {
                    feedPosts[index].postDetails.comments.remove(at: index)
                    
                    feedsTable.scrollToRow(at: IndexPath(row: mainIndex, section: 0), at: .none, animated: true)
                    feedsTable.reloadRows(at: [IndexPath(row: mainIndex, section: 0)], with: .none)
                }
            }
        }
    }
    
    @objc private func likePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [Int: [String]], let data = data[1] {
            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == Int(data[0])! && feedPost.postDetails.postID == Int(data[1])!  {
                feedPosts[index].postDetails.likes.insert(Int(data[2])!)
                
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                feedsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    @objc private func unlikePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [Int] {
            
            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == data[0] && feedPost.postDetails.postID == data[1] {
                
                let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
                feedPosts[index].postDetails.likes.remove(loggedUserID)
                
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: true)
                feedsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    @objc private func createPost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? FeedsDetails {
            feedPosts.insert(data, at: 0)
            feedsTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }
    
    @objc private func updatePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? FeedsDetails {


            for (_,feedPost) in feedPosts.enumerated() where feedPost.userID == data.userID && feedPost.postDetails.postID == data.postDetails.postID {

                if feedPost.postDetails.isArchived != data.postDetails.isArchived {
                    for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == data.userID && feedPost.postDetails.postID == data.postDetails.postID {

                        feedPosts.remove(at: index)
                        feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                        feedsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                        shouldBackgroundBeChanged()
                    }
                    return
                }
            }

            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == data.userID && feedPost.postDetails.postID == data.postDetails.postID {

                feedPosts[index] = data
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                feedsTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                shouldBackgroundBeChanged()
                return
            }

            feedPosts.insert(data, at: 0)
            feedsTable.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }
    
    @objc private func deletePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? ListCollectionDetails {
            
            for (index,feedPost) in feedPosts.enumerated() where feedPost.userID == data.userID && feedPost.postDetails.postID == data.postID {
                
                feedPosts.remove(at: index)
                
                feedsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                feedsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                shouldBackgroundBeChanged()
            }
        }
    }
    
    private func shouldBackgroundBeChanged() {
        feedsTable.backgroundView?.alpha = feedPosts.count > 0 ? 0.0 : 1.0
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
            postDetails: feedPosts[indexPath.row].postDetails,
            isSaved: feedPosts[indexPath.row].isSaved)
        
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
            likedUsersCount: feedPosts[indexPath.row].postDetails.likes.count,
            commentedUsersCount: feedPosts[indexPath.row].postDetails.comments.count,
            postCreatedTime: feedPosts[indexPath.row].postDetails.postCreatedDate,
            isDeletionAllowed: feedsControls.isDeletionAllowed(userID: feedPosts[indexPath.row].userID),
            isLikesHidden: feedPosts[indexPath.row].postDetails.isLikesHidden,
            isCommentsHidden: feedPosts[indexPath.row].postDetails.isCommentsHidden,
            isSaved: feedPosts[indexPath.row].isSaved
        )
        
        return particularCell
    }
}

extension FeedsVC: FeedsCustomCellDelegate {
    
    func popAViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func confirmDeletion(sender: FeedsCustomCell) {
        
        let confirmDeletion = UIAlertController(title: "Confirm Delete?", message: "You won't be able to retrieve it later.", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deletePost(sender: sender)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmDeletion.addAction(confirm)
        confirmDeletion.addAction(cancel)
        
        present(confirmDeletion, animated: true)
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
        NotificationCenter.default.post(name: Constants.unlikePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: [postUserID,postID]])
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
        let userID = feedPosts[indexPath.row].userID
        
        if feedsControls.deletePost(postID: postID) {
            NotificationCenter.default.post(name: Constants.deletePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: ListCollectionDetails(userID: userID, postID: postID)])
        } else {
            showToast(message: Constants.toastFailureStatus)
        }
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
    
    func unfollowUser(sender: FeedsCustomCell) {
        let indexPath = feedsTable.indexPath(for: sender)!
        let userID = feedPosts[indexPath.row].userID
        
        if !feedsControls.removeFriend(profileRequestedUser: userID) {
            showToast(message: Constants.toastFailureStatus)
        }
        
        NotificationCenter.default.post(name: Constants.removeFriendPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: userID])
        
    }
    
    func addPostToSaved(sender: FeedsCustomCell) {
        let indexPath = feedsTable.indexPath(for: sender)!
        
        if feedsControls.addPostToSaved(
            postUserID: feedPosts[indexPath.row].userID,
            postID: feedPosts[indexPath.row].postDetails.postID) {
            
            
        }
    }
    
    func removePostFromSaved(sender: FeedsCustomCell) {
        
        let indexPath = feedsTable.indexPath(for: sender)!
        if feedsControls.removePostFromSaved(
            postUserID: feedPosts[indexPath.row].userID,
            postID: feedPosts[indexPath.row].postDetails.postID) {
            
            NotificationCenter.default.post(name: Constants.unsavingPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: ListCollectionDetails(userID: feedPosts[indexPath.row].userID, postID: feedPosts[indexPath.row].postDetails.postID)])
        }
    }
}
