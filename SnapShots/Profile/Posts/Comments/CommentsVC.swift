//
//  CommentsVC.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class CommentsVC: UIViewController {
    
    private var commentDetails: [CommentDetails] = []
    private var postUserID: Int
    private var postID: Int
    private var commentsControls: CommentsControlsProtocol
    
    init(commentsControls: CommentsControlsProtocol,postUserID: Int,postID: Int) {
        self.commentsControls = commentsControls
        self.postUserID = postUserID
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var commentsTable: UITableView = {
        var comments = UITableView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        return comments
    }()
    
    private lazy var postComment: UIButton = {
        let postComment = UIButton()
        postComment.setTitle("POST   ", for: .normal)
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
        addComments.backgroundColor = .systemBackground
        addComments.layer.borderColor = UIColor(named: "appTheme")?.cgColor
        addComments.layer.borderWidth = 2
        addComments.layer.cornerRadius = 20
        addComments.textColor = UIColor(named: "appTheme")
     
        addComments.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        addComments.leftViewMode = .always
        addComments.rightView = postComment
        addComments.rightViewMode = .always
        return addComments
    }()
    
    private lazy var emptyCommentsLabel: UILabel = {
        let emptyComments = UILabel()
        emptyComments.text = "No Comments yet. Be the first."
        emptyComments.font = UIFont.boldSystemFont(ofSize: 25)
        emptyComments.numberOfLines = 2
        emptyComments.textAlignment = .center
        emptyComments.textColor = UIColor(named: "appTheme")
        return emptyComments
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupNavigationItems()
        setupCommentsTable()
        setupConstraints()
        getComments()
        addCommentTextField.delegate = self
        postComment.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        
        setupNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(insertComment(_:)), name: Constants.insertCommentPostEvent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteComment(_:)), name: Constants.deleteCommentPostEvent, object: nil)
    }
    
    @objc private func insertComment(_ notification: NSNotification) {
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? [Int:[String]] {
            commentDetails.append(CommentDetails(
                commentID: Int(data[1]![0])!,
                username: commentsControls.getUsername(userID: Int(data[1]![4])!),
                comment: data[1]![3],
                commentUserID: Int(data[1]![4])!)
            )
            
            commentsTable.insertRows(at: [IndexPath(row: commentDetails.count - 1, section: 0)], with: .none)
        }
    }
    
    @objc private func deleteComment(_ notification: NSNotification) {
        
        if let data = notification.userInfo?[Constants.notificationCenterKeyName] as? Int {
            
            for (index,commentDetail) in commentDetails.enumerated() where commentDetail.commentID == data {
                
                commentDetails.remove(at: index)
                
                commentsTable.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
                commentsTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if ((previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection)) != nil) {
            addCommentTextField.layer.borderColor = UIColor(named: "appTheme")?.cgColor
        }
    }
    
    private func setupNavigationItems() {
        title = "Comments"
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
    }
    
    func setupCommentsTable() {
        commentsTable.register(CommentsCustomCell.self, forCellReuseIdentifier: CommentsCustomCell.identifier)
        commentsTable.separatorStyle = .none
        commentsTable.delegate = self
        commentsTable.dataSource = self
        commentsTable.estimatedRowHeight = 40
        commentsTable.rowHeight = UITableView.automaticDimension
        commentsTable.backgroundView = emptyCommentsLabel
    }
    
    func getComments() {
        commentDetails = commentsControls.getAllComments(postUserID: postUserID, postID: postID)
        if commentDetails.isEmpty {
            commentsTable.backgroundView?.alpha = 1.0
        } else {
            commentsTable.backgroundView?.alpha = 0.0
        }
    }
    
    func setupConstraints() {
        
        [commentsTable,addCommentTextField].forEach {
            view.addSubview($0)
        }
    
        NSLayoutConstraint.activate([
            
            addCommentTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            addCommentTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -8),
            addCommentTextField.heightAnchor.constraint(equalToConstant: 50),
            
            commentsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            commentsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            commentsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            commentsTable.bottomAnchor.constraint(equalTo: addCommentTextField.topAnchor)
        ])
        
        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: addCommentTextField.bottomAnchor,constant: 10)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
    }
}

extension CommentsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)
        
        let profileControls = ProfileControls()
        let profileVC = ProfileVC(
            profileControls: profileControls,
            userID: commentDetails[indexPath.row].commentUserID,
            isVisiting: true)
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentDetails.count
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 2 || velocity.y < -2 {
            self.view.endEditing(true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCustomCell.identifier, for: indexPath) as! CommentsCustomCell
        
        cell.delegate = self
        
        let profilePicture = AppUtility.getDisplayPicture(userID: commentDetails[indexPath.row].commentUserID)
        
        cell.configure(
            userDP: profilePicture,
            username: commentDetails[indexPath.row].username,
            comment: commentDetails[indexPath.row].comment,
            hasSpecialPermission: commentsControls.hasSpecialPermissions(postUserID: postUserID)
        )
        
 
        return cell
    }

    @objc func addComment() {

        if !commentsControls.addComment(postUserID: postUserID, postID: postID, comment: addCommentTextField.text!) {
            showToast(message: Constants.toastFailureStatus)
            return
        }
        
        addCommentTextField.text = nil
        getComments()
    }
}

extension CommentsVC : UITextFieldDelegate {
    
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

extension CommentsVC: CommentsCustomCellDelegate {
    func deleteComment(sender: CommentsCustomCell) {
        
        let indexPath = commentsTable.indexPath(for: sender)!
        let commentID = commentDetails[indexPath.row].commentID
        
        commentsControls.deleteComment(userID: postUserID, postID: postID, commentID: commentID)
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
