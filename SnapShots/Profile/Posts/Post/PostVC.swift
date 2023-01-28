//
//  PostVCDup.swift
//  SnapShots
//
//  Created by mahendran-14703 on 26/12/22.
//

import UIKit

class PostVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private var postImage: UIImage
    private var postDetails: Post
    private var postControls: PostControlsProtocol
    private var userID: Int
    private var likeFlag: Bool!
    private var isSaved: Bool
    private var commentDetails: [CommentDetails] = []

    init(postControls: PostControlsProtocol,userID: Int,postImage: UIImage,postDetails: Post,isSaved: Bool) {
        self.postControls = postControls
        self.userID = userID
        self.postImage = postImage
        self.postDetails = postDetails
        self.isSaved = isSaved
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var postTable: UITableView = {
        let postTable = UITableView(frame: .zero, style: .grouped)
        postTable.translatesAutoresizingMaskIntoConstraints = false
        return postTable
    }()

    private lazy var postComment: UIButton = {
        let postComment = UIButton()
        postComment.setTitle(" POST   ", for: .normal)
        postComment.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        postComment.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        postComment.alpha = 0.5
        postComment.isUserInteractionEnabled = false
        return postComment
    }()

    private lazy var addCommentTextField: UITextField = {
        var addComments = UITextField()
        addComments.placeholder = "Add Comment"
        addComments.clearsOnBeginEditing = true
        addComments.translatesAutoresizingMaskIntoConstraints = false
        addComments.layer.borderColor = UIColor(named: "appTheme")?.cgColor
        addComments.layer.borderWidth = 2
        addComments.layer.cornerRadius = 20
        addComments.textColor = UIColor(named: "appTheme")

        addComments.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 0))
        addComments.leftViewMode = .always
        addComments.rightView = postComment
        addComments.rightViewMode = .always
        return addComments
    }()

    private lazy var snapShotsLogo: UIImageView = {
        let snapShotsLogo = UIImageView()
        snapShotsLogo.image = UIImage(named: "SnapShotsLogo")
        snapShotsLogo.contentMode = .scaleAspectFit
        snapShotsLogo.isUserInteractionEnabled = true
        return snapShotsLogo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()
        setupPostTable()
        setupTapGestures()
        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(deletePost(_:)), name: Constants.deletePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePost(_:)), name: Constants.updatePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likePost(_:)), name: Constants.likePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unlikePost(_:)), name: Constants.unlikePostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(insertComment(_:)), name: Constants.insertCommentPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteComment(_:)), name: Constants.deleteCommentPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(savePost(_:)), name: Constants.savingPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unSavePost(_:)), name: Constants.unsavingPostEvent, object: nil)
    }
    
    @objc private func savePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? ListCollectionDetails {
            
            if !(userID == data.userID && postDetails.postID == data.postID) {
                return
            }
            
            isSaved = true
            let headerView = postTable.headerView(forSection: 0) as! PostVCHeader
            setHeaderData(headerView)
        }
    }
    
    @objc private func unSavePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? ListCollectionDetails {
            
            if !(userID == data.userID && postDetails.postID == data.postID) {
                return
            }
            
            isSaved = false
            let headerView = postTable.headerView(forSection: 0) as! PostVCHeader
            setHeaderData(headerView)
        }
    }
    
    @objc private func insertComment(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [Int:[String]] {
            
            if !(Int(data[1]![1])! == userID && Int(data[1]![2])! == postDetails.postID) {
                    return
            }
            
            commentDetails.append(CommentDetails(
                commentID: Int(data[1]![0])!,
                username: postControls.getUsername(userID: Int(data[1]![4])!),
                comment: data[1]![3],
                commentUserID: Int(data[1]![4])!)
            )
            
            postTable.insertRows(at: [IndexPath(row: commentDetails.count - 1, section: 0)], with: .none)
        }
    }
    
    @objc private func deleteComment(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
            
            for (index,commentDetail) in commentDetails.enumerated() where commentDetail.commentID == data {
                
                commentDetails.remove(at: index)
                
                postTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                postTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
    }
    
    @objc private func likePost(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [Int:[String]] {
            
            if !(Int(data[1]![0])! == userID && Int(data[1]![1])! == postDetails.postID) {
                    return
            }
            
            let likedUserID = Int(data[1]![2])!
            
            postDetails.likes.insert(likedUserID)
            likeFlag = true
            
            let headerView = postTable.headerView(forSection: 0) as! PostVCHeader
            setHeaderData(headerView)
        }
    }
    
    @objc private func unlikePost(_ notification: NSNotification) {
        
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        postDetails.likes.remove(loggedUserID)
        likeFlag = false
        
        let headerView = postTable.headerView(forSection: 0) as! PostVCHeader
        setHeaderData(headerView)
    }
    
    @objc private func updatePost(_ notification: NSNotification) {
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? FeedsDetails {

            postDetails = data.postDetails
            isSaved = data.isSaved

            if postDetails.isArchived {
                navigationController?.popViewController(animated: true)
            }

            let headerView = postTable.headerView(forSection: 0) as! PostVCHeader
            setHeaderData(headerView)

            if postDetails.isCommentsHidden {
                addCommentTextField.isHidden = true
                postTable.reloadData()
            } else {
                addCommentTextField.isHidden = false
                postTable.reloadData()
            }
        }
    }
    
    @objc private func deletePost(_ notification: NSNotification) {
        navigationController?.popViewController(animated: true)
     }
    
    private func setNavigationItems() {
        view.backgroundColor = .systemBackground
        postTable.backgroundColor = .systemBackground
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        navigationItem.titleView = snapShotsLogo
        
        addCommentTextField.delegate = self
    }
    
    func setupTapGestures() {
        postComment.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        snapShotsLogo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollToScreenTop)))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if ((previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection)) != nil) {
            addCommentTextField.layer.borderColor = UIColor(named: "appTheme")?.cgColor
        }
    }

    private func setupPostTable() {
        
        likeFlag = postControls.isAlreadyLikedThePost(postUserID: userID, postID: postDetails.postID)

        postTable.register(PostVCHeader.self, forHeaderFooterViewReuseIdentifier: PostVCHeader.identifier)

        postTable.register(CommentsCustomCell.self, forCellReuseIdentifier: CommentsCustomCell.identifier)

        postTable.delegate = self
        postTable.dataSource = self
        
        setupPostTableConstraints()
        commentDetails = postControls.getAllComments(postUserID: userID, postID: postDetails.postID)
    }

    private func setHeaderData(_ headerView: PostVCHeader) {
        
        headerView.configure(
            profilePhoto: postControls.getUserDP(userID: userID),
            username: postControls.getUsername(userID: userID),
            postPhoto: postImage,
            caption: postDetails.caption,
            postCreatedTime: String(AppUtility.getDate(date: postDetails.postCreatedDate)),
            likeCount: postDetails.likes.count,
            commentsCount: postDetails.comments.count,
            isAlreadyLiked: likeFlag,
            isDeletionAllowed: postControls.isDeletionAllowed(userID: userID),
            isLikesCountHidden: postDetails.isLikesHidden,
            isCommentsHidden: postDetails.isCommentsHidden,
            isArchived: postDetails.isArchived,
            isSaved: isSaved
        )
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostVCHeader.identifier) as! PostVCHeader

        headerView.delegate = self

        setHeaderData(headerView)
        
        return headerView
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if velocity.y > 2 || velocity.y < -2 {
            self.view.endEditing(true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postControls.getCommentsButtonVisibilityState(userID: userID, postID: postDetails.postID) {
            addCommentTextField.isHidden = true
            return 0
        }
        
        addCommentTextField.isHidden = false
        return commentDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCustomCell.identifier, for: indexPath) as! CommentsCustomCell

        let profilePicture = AppUtility.getDisplayPicture(userID: commentDetails[indexPath.row].commentUserID)
        
        cell.delegate = self
        cell.configure(
            userDP: profilePicture,
            username: commentDetails[indexPath.row].username,
            comment: commentDetails[indexPath.row].comment,
            hasSpecialPermission: postControls.hasSpecialPermissions(postUserID: postDetails.postID))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    private func setupPostTableConstraints() {
        [postTable,addCommentTextField].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([

            addCommentTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            addCommentTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            addCommentTextField.heightAnchor.constraint(equalToConstant: 40),

            postTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postTable.bottomAnchor.constraint(equalTo: addCommentTextField.topAnchor),
            postTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            postTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: addCommentTextField.bottomAnchor,constant: 8)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
    }

    @objc func addComment() {

        if !postControls.addComment(postUserID: userID, postID: postDetails.postID, comment: addCommentTextField.text!) {
            showToast(message: Constants.toastFailureStatus)
            return
        }

        addCommentTextField.text = nil
        postTable.scrollToRow(at: IndexPath(item:commentDetails.count-1, section: 0), at: .bottom, animated: true)
    }

    @objc func scrollToScreenTop() {

       let ip = IndexPath(row: 0, section: 0)

        if postTable.indexPathsForVisibleRows!.contains(ip){
           postTable.scrollToRow(at: ip, at: .top, animated: true)
        }
    }
}

extension PostVC: PostVCHeaderDelegate {
    
    func popAViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func confirmDeletion() {
        
        let confirmDeletion = UIAlertController(title: "Confirm Delete?", message: "You won't be able to retrieve it later.", preferredStyle: .alert)

        confirmDeletion.addAction(
            UIAlertAction(title: "Delete", style: .destructive) { _ in

                if !self.deletePost() {
                    self.showToast(message: Constants.toastFailureStatus)
                    return
                }

                NotificationCenter.default.post(name: Constants.deletePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: ListCollectionDetails(userID: self.userID, postID: self.postDetails.postID)])
                
                self.navigationController?.popViewController(animated: true)
            }
        )

        confirmDeletion.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )

        present(confirmDeletion, animated: true)
    }

    func likeThePost() {
        _ = postControls.addLikeToThePost(postUserID: userID, postID: postDetails.postID)
    }

    func unLikeThePost() {
        _ = postControls.removeLikeFromThePost(postUserID: userID, postID: postDetails.postID)
        NotificationCenter.default.post(name: Constants.unlikePostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: [userID,postDetails.postID]])
    }

    func deletePost() -> Bool {
        return postControls.deletePost(postID: postDetails.postID)
    }

    func displayAllLikesUsers() {

        let likesControls = LikesControls()
        let likesVC = LikesVC(likesControls: likesControls, postUserID: userID, postID: postDetails.postID)

        navigationController?.pushViewController(likesVC, animated: true)
    }

    func openCommentBox() {
        addCommentTextField.becomeFirstResponder()
    }
    
    func unfollowUser() {
        
        if !postControls.removeFriend(profileRequestedUser: userID) {
            showToast(message: Constants.toastFailureStatus)
        }
        
        NotificationCenter.default.post(name: Constants.removeFriendPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: userID])
        navigationController?.popViewController(animated: true)
    }
    
    func hideLikesCount() {
        postControls.hideLikesCount(userID: userID, postID: postDetails.postID)
        postDetails.isLikesHidden = true
    }
    
    func unhideLikesCount() {
        postControls.unhideLikesCount(userID: userID, postID: postDetails.postID)
        postDetails.isLikesHidden = false
    }
    
    func hideComments() {
        postControls.hideComments(userID: userID, postID: postDetails.postID)
    }
    
    func unhideComments() {
        postControls.unhideComments(userID: userID, postID: postDetails.postID)
    }
    
    func archiveThePost() {
        _ = postControls.archiveThePost(userID: userID,postID: postDetails.postID) 
    }
    
    func unarchiveThePost() {
        _ = postControls.unarchiveThePost(userID: userID,postID: postDetails.postID)
    }
    
    func addPostToSaved() {
        _ = postControls.addPostToSaved(postUserID: userID, postID: postDetails.postID)
       
    }
    
    func removePostFromSaved() {
        _ = postControls.removePostFromSaved(postUserID: userID, postID: postDetails.postID)
        
        NotificationCenter.default.post(name: Constants.unsavingPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: ListCollectionDetails(userID: userID, postID: postDetails.postID)])
    }
    
}

extension PostVC : UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {

        if !textField.text!.isEmpty && !textField.text!.trimmingCharacters(in: .whitespaces).isEmpty  {
            postComment.alpha = 1.0
            postComment.isUserInteractionEnabled = true
        } else {
            postComment.alpha = 0.5
            postComment.isUserInteractionEnabled = false
        }
    }
}


extension PostVC: CommentsCustomCellDelegate {
    
    func deleteComment(sender: CommentsCustomCell) {
        
        let indexPath = postTable.indexPath(for: sender)!
        let commentID = commentDetails[indexPath.row].commentID
        
        postControls.deleteComment(userID: userID, postID: postDetails.postID, commentID: commentID)
        NotificationCenter.default.post(name: Constants.deleteCommentPostEvent, object: nil,userInfo: [Constants.notificationCenterKeyName: commentID])
    }
    
    func showCommentDeletionAlert(sender: CommentsCustomCell) {
        sender.backgroundColor = .lightGray
        
        let deleteCommentAlert = UIAlertController(title: "Delete Comment?", message: nil, preferredStyle: .alert)
        
        deleteCommentAlert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteComment(sender: sender)
            sender.backgroundColor = .systemBackground
        })
        
        deleteCommentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            sender.backgroundColor = .systemBackground
        })
        
        self.present(deleteCommentAlert, animated: true)
    }
}
