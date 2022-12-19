//
//  PostViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class PostVC: UIViewController {

    private var postImage: UIImage
    private var postDetails: Post
    private var postControls: PostControlsProtocol
    private var userID: Int
    private var likeFlag: Bool!
    
    init(postControls: PostControlsProtocol,userID: Int,postImage: UIImage,postDetails: Post) {
        self.postControls = postControls
        self.userID = userID
        self.postImage = postImage
        self.postDetails = postDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var scrollContainer: UIView = {
        let scrollContainer = UIView()
        scrollContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollContainer.backgroundColor = .systemBackground
        return scrollContainer
    }()
    
    private lazy var profilePhoto: UIImageView = {
        let profileImage = UIImageView(frame: .zero)
        profileImage.image = postControls.getUserDP(userID: userID)
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.isUserInteractionEnabled = true
        return profileImage
    }()
    
    private lazy var userNameLabel: UILabel = {
        var userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.systemFont(ofSize:17)
        userNameLabel.text = postControls.getUsername(userID: userID)
        return userNameLabel
    }()
    
    private lazy var moreInfo: UIButton = {
        var moreInfo = UIButton(type: .custom)
        moreInfo.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreInfo.translatesAutoresizingMaskIntoConstraints = false
        moreInfo.tintColor = UIColor(named: "appTheme")
        moreInfo.backgroundColor = UIColor(named: "moreInfo_bg_color")
        return moreInfo
    }()
    
    private lazy var post: UIImageView = {
       let post = UIImageView()
       post.clipsToBounds = true
       post.image = postControls.getPostImage(postImageName: postDetails.photo)
       post.contentMode = .scaleAspectFill
       post.translatesAutoresizingMaskIntoConstraints = false
       post.isUserInteractionEnabled = true
       post.layer.cornerRadius = 15
       return post
    }()
    
    private lazy var caption: UILabel = {
        var caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = postDetails.caption
        caption.font = UIFont.systemFont(ofSize:15)
        caption.numberOfLines = 10
        return caption
    }()
    
    private lazy var like: UIButton = {
        var like = UIButton()
        like.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        like.translatesAutoresizingMaskIntoConstraints = false
        like.contentMode = .scaleAspectFill
        like.isUserInteractionEnabled = true
        like.tintColor = .red
        return like
    }()
    
    private lazy var likesCount: UILabel = {
        let likesCount = UILabel()
        likesCount.text = "0"
        likesCount.translatesAutoresizingMaskIntoConstraints = false
        likesCount.textColor = .red
        return likesCount
    }()
    
    private lazy var comment: UIButton = {
        var comment = UIButton()
        comment.setBackgroundImage(UIImage(systemName: "ellipsis.message"), for: .normal)
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.contentMode = .scaleAspectFill
        comment.isUserInteractionEnabled = true
        return comment
    }()
    
    private lazy var commentsCount: UILabel = {
        let commentsCount = UILabel()
        commentsCount.text = "0"
        commentsCount.translatesAutoresizingMaskIntoConstraints = false
        commentsCount.textColor = .systemBlue
        return commentsCount
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupNavigationItems()
        setupConstraints()
        setupTapGestures()
        setLikeButton()
        
        profilePhoto.layer.cornerRadius = 40/2
        moreInfo.layer.cornerRadius = 15
    }
    
    private func setupTapGestures() {
        like.addTarget(self, action: #selector(reactToThePost(_:)), for: .touchUpInside)
        comment.addTarget(self, action: #selector(goToComments), for: .touchUpInside)
        moreInfo.addTarget(self, action: #selector(showOwnerMenu(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationItems() {
        title = "Posts"
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
        navigationController?.navigationBar.isOpaque = true
    }
    
    private func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [profilePhoto,userNameLabel,moreInfo,post,like,likesCount,comment,commentsCount,caption].forEach {
            scrollContainer.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profilePhoto.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 4),
            profilePhoto.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 12),
            profilePhoto.heightAnchor.constraint(equalToConstant: 40),
            profilePhoto.widthAnchor.constraint(equalToConstant: 40),
            
            moreInfo.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 10),
            moreInfo.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -12),
            moreInfo.heightAnchor.constraint(equalToConstant: 30),
            moreInfo.widthAnchor.constraint(equalToConstant: 30),
            
            userNameLabel.topAnchor.constraint(equalTo: scrollContainer.topAnchor,constant: 4),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: moreInfo.leadingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            post.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 8),
            post.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 12),
            post.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -12),
            post.heightAnchor.constraint(equalToConstant: 350),
            
            like.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 12),
            like.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 4),
            like.heightAnchor.constraint(equalToConstant: 33),
            like.widthAnchor.constraint(equalToConstant: 35),
            
            likesCount.leadingAnchor.constraint(equalTo: like.trailingAnchor,constant: 4),
            likesCount.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 4),
            likesCount.heightAnchor.constraint(equalToConstant: 33),
            likesCount.widthAnchor.constraint(equalToConstant: 50),
            
            comment.leadingAnchor.constraint(equalTo: likesCount.trailingAnchor,constant: 4),
            comment.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 6),
            comment.heightAnchor.constraint(equalToConstant: 30),
            comment.widthAnchor.constraint(equalToConstant: 35),
            
            commentsCount.leadingAnchor.constraint(equalTo: comment.trailingAnchor,constant: 4),
            commentsCount.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 4),
            commentsCount.heightAnchor.constraint(equalToConstant: 33),
            commentsCount.widthAnchor.constraint(equalToConstant: 55),
            
            caption.topAnchor.constraint(equalTo: like.bottomAnchor,constant: 8),
            caption.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 12),
            caption.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -12),
            caption.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        ])
    }
    
    private func setLikeButton() {
        likeFlag = postControls.isAlreadyLikedThePost(postUserID: userID, postID: postDetails.postID)
        
        self.likesCount.text = String( Double(postControls.getAllLikedUsers(postUserID: userID, postID: postDetails.postID)).shortStringRepresentation )
        
        self.commentsCount.text = String( Double(postControls.getAllComments(postUserID: userID, postID: postDetails.postID)).shortStringRepresentation )
        
        setLikeHeartImage(isLiked: likeFlag)
    }

    @objc private func reactToThePost(_ sender : UITapGestureRecognizer) {
        
        likeFlag = !likeFlag
        if likeFlag {
            setLikeHeartImage(isLiked: likeFlag)
            likesCount.text = String( Int(likesCount.text!)! + 1)
            if !postControls.addLikeToThePost(postUserID: userID, postID: postDetails.postID) {
                showToast(message: Constants.toastFailureStatus)
            }
        } else {
            setLikeHeartImage(isLiked: likeFlag)
            likesCount.text = String( Int(likesCount.text!)! - 1)
            if !postControls.removeLikeFromThePost(postUserID: userID, postID: postDetails.postID) {
                showToast(message: Constants.toastFailureStatus)
            }
        }
       
        NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
    }
    
    private func setLikeHeartImage(isLiked: Bool) {
        if isLiked {
            like.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            like.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc private func goToLikes() {
        let likesControl = LikesControls()
        self.navigationController?.pushViewController(LikesVC(likesControls: likesControl, postUserID: userID, postID: postDetails.postID), animated: true)
    }
    
    @objc private func goToComments() {
        
        let commentsControl = CommentsControls()
        self.navigationController?.pushViewController(CommentsVC(commentsControls: commentsControl, postUserID: userID, postID: postDetails.postID), animated: true)
    }
    
    @objc private func showOwnerMenu(_ sender: UIButton) {
    
        let moreInfo = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let allLikes = UIAlertAction(title: "All Likes", style: .default) { _ in
            self.goToLikes()
        }
        
        if postControls.isDeletionAllowed(userID: userID) {
            let deletePost = UIAlertAction(title: "Delete", style: .default) { _ in
                self.confirmDeletion()
            }
            moreInfo.addAction(deletePost)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)

        moreInfo.addAction(allLikes)
        moreInfo.addAction(cancel)
        
        present(moreInfo, animated: true)
    }
    
    private func confirmDeletion() {
        
        let confirmDeletion = UIAlertController(title: "Confirm Delete?", message: "You won't be able to retrieve it later.", preferredStyle: .alert)
        
        confirmDeletion.addAction(
            UIAlertAction(title: "Delete", style: .destructive) { _ in
                
                if !self.postControls.deletePost(postID: self.postDetails.postID) {
                    self.showToast(message: Constants.toastFailureStatus)
                    return
                }
                
                NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        )
        
        confirmDeletion.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(confirmDeletion, animated: true)
        
    }
}
