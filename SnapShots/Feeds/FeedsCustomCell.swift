//
//  FeedsCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 23/11/22.
//

import UIKit

protocol FeedsCustomCellDelegate: AnyObject {
    func likeThePost(sender: FeedsCustomCell)
    func unLikeThePost(sender: FeedsCustomCell)
    func showLikes(sender: FeedsCustomCell)
    func showComments(sender: FeedsCustomCell)
    func deletePost(sender: FeedsCustomCell)
    func goToProfile(sender: FeedsCustomCell)
    func unfollowUser(sender: FeedsCustomCell)
    func addPostToSaved(sender: FeedsCustomCell)
    func removePostFromSaved(sender: FeedsCustomCell)
    func popAViewController()
    func confirmDeletion(sender: FeedsCustomCell)
}

class FeedsCustomCell: UITableViewCell {
    
    static let identifier = "FeedsCustomCell"
    private var likeFlag: Bool = false
    private var isSaved: Bool = false
    weak var delegate: FeedsCustomCellDelegate?
    private var isDeletionAllowed: Bool = false
    private var isLikesHidden: Bool!
    
    private lazy var postContainer: UIView = {
        var postContainer = UIView()
        postContainer.translatesAutoresizingMaskIntoConstraints = false
        postContainer.clipsToBounds = true
        postContainer.layer.cornerRadius = 10
        postContainer.layer.borderWidth = 0.5
        postContainer.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        postContainer.backgroundColor = UIColor(named: "post_bg_color")
        return postContainer
    }()
    
    private lazy var profilePhoto: UIImageView = {
        let profileImage = UIImageView(frame: .zero)
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
        userNameLabel.isUserInteractionEnabled = true
        return userNameLabel
    }()
    
    private lazy var moreInfo: UIButton = {
        var moreInfo = CustomButton(selectColour: UIColor(named: "moreInfo_bg_color")!, deselectColour: UIColor(named: "moreInfo_bg_color")!)
        moreInfo.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreInfo.translatesAutoresizingMaskIntoConstraints = false
        moreInfo.tintColor = UIColor(named: "appTheme")
        moreInfo.backgroundColor = UIColor(named: "moreInfo_bg_color")
        return moreInfo
    }()
    
    private lazy var post: UIImageView = {
        let post = UIImageView()
        post.clipsToBounds = true
        post.contentMode = .scaleAspectFill
        post.translatesAutoresizingMaskIntoConstraints = false
        post.isUserInteractionEnabled = true
        post.layer.cornerRadius = 15
        return post
    }()

    private lazy var likesButton: UIButton = {
        
        var configButton = UIButton.Configuration.borderless()
        configButton.imagePadding = 6
        
        let button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = UIColor(named: "appTheme")!
        button.imageView?.contentMode = .scaleAspectFill
 
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        var configButton = UIButton.Configuration.borderless()
        configButton.imagePadding = 6
        configButton.contentInsets = .zero
                
        let button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(UIImage(systemName: "ellipsis.message"), for: .normal)
        button.tintColor = UIColor(named: "appTheme")!

        return button
    }()
    
    private lazy var caption: UILabel = {
        var caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.font = UIFont.systemFont(ofSize:15)
        caption.numberOfLines = 0
        return caption
    }()
    
    private lazy var postCreatedTime: UILabel = {
        var postCreatedTime = UILabel()
        postCreatedTime.translatesAutoresizingMaskIntoConstraints = false
        postCreatedTime.font = UIFont.systemFont(ofSize: 10)
        postCreatedTime.textAlignment = .left
        return postCreatedTime
    }()
    
    private lazy var saveButton: UIButton = {
        var configButton = UIButton.Configuration.borderless()
        configButton.imagePadding = 6
        configButton.contentInsets = .zero
                
        let saveButton = UIButton(configuration: configButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        saveButton.tintColor = UIColor(named: "appTheme")!

        return saveButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(postContainer)
        
        setupConstraint()
        setupButtonTargets()
        profilePhoto.layer.cornerRadius = 40/2
        moreInfo.layer.cornerRadius = 15
    }
    
    func configure(
        profilePhoto: UIImage,
        username: String,
        postPhoto: UIImage,
        postCaption: String,
        isAlreadyLiked: Bool,
        likedUsersCount: Int,
        commentedUsersCount: Int,
        postCreatedTime: String,
        isDeletionAllowed: Bool,
        isLikesHidden: Bool,
        isCommentsHidden: Bool,
        isSaved: Bool) {
        
        
        self.profilePhoto.image = profilePhoto
        self.userNameLabel.text = username
        self.post.image = postPhoto
        self.caption.text = postCaption
        self.likeFlag = isAlreadyLiked
        self.postCreatedTime.text = String(AppUtility.getDate(date: postCreatedTime))
        self.isLikesHidden = isLikesHidden
        self.commentButton.setTitle(String( Double(commentedUsersCount).shortStringRepresentation), for: .normal)
        self.commentButton.isHidden = isCommentsHidden ? true : false
        self.isSaved = isSaved
            
        setLikeHeartImage(isLiked: likeFlag)
        setSavedCollectionImage(isSaved: isSaved)
        setupMoreInfoButtonActions(isDeletionAllowed: isDeletionAllowed)
        changeLikesButtonState(isLikesCountHidden: isLikesHidden, likeCount: likedUsersCount)
    }
    
    private func changeLikesButtonState(isLikesCountHidden: Bool,likeCount: Int) {
        if isLikesCountHidden {
            likesButton.titleLabel?.layer.opacity = 0.0
            return
        }
        
        self.likesButton.setTitle(String( Double(likeCount).shortStringRepresentation), for: .normal)
        likesButton.titleLabel?.layer.opacity = 1.0
    }
    
    private func setupButtonTargets() {
        likesButton.addTarget(self, action: #selector(reactToThePost(_:)), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(gotToComments), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(savePost), for: .touchUpInside)
        
        profilePhoto.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        )
        
        userNameLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        )
    }
    
    @objc private func savePost() {
        
        isSaved = !isSaved
        setSavedCollectionImage(isSaved: isSaved)
        if isSaved {
            delegate?.addPostToSaved(sender: self)
        } else {
            delegate?.removePostFromSaved(sender: self)
        }
    }
    
    private func setSavedCollectionImage(isSaved: Bool) {
        let image = isSaved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        let imageColor = UIColor(named: "appTheme")
        
        saveButton.setImage(image, for: .normal)
        saveButton.tintColor = imageColor
    }
    
    @objc private func reactToThePost(_ sender : UITapGestureRecognizer) {
       
        likeFlag = !likeFlag
        setLikeHeartImage(isLiked: likeFlag)

        if likeFlag {
            if !isLikesHidden {
                self.likesButton.setTitle(
                    String(Int((self.likesButton.titleLabel?.text!)!)! + 1),
                    for: .normal)
            }
    
            delegate?.likeThePost(sender: self)
            
        } else {
            if !isLikesHidden {
                self.likesButton.setTitle(
                    String( Int((self.likesButton.titleLabel?.text!)!)! - 1),
                    for: .normal)
            }
            delegate?.unLikeThePost(sender: self)
        }
    }
        
    private func setLikeHeartImage(isLiked: Bool) {
        
        let image = isLiked ? UIImage(systemName: "suit.heart.fill") : UIImage(systemName: "suit.heart")
        let imageColour = isLiked ? UIColor.red : UIColor(named: "appTheme")
        
        likesButton.setImage(image, for: .normal)
        likesButton.tintColor = imageColour
    }
    
    @objc private func goToLikes() {
        delegate?.showLikes(sender: self)
    }
    
    @objc private func gotToComments() {
        delegate?.showComments(sender: self)
    }
    
    @objc private func goToProfile() {
        delegate?.goToProfile(sender: self)
    }
    
    func setupMoreInfoButtonActions(isDeletionAllowed: Bool) {
        let deletePost = UIAction(
          title: "Delete",
          image: UIImage(systemName: "trash"),
          attributes: .destructive) { _ in
              
            self.confirmDeletion()
        }
        
        
        let unfollowUser = UIAction(
          title: "Unfollow User",
          image: UIImage(systemName: "person.badge.minus")) { _ in
              
              self.delegate?.unfollowUser(sender: self)            
              self.delegate?.popAViewController()
        }
        
        moreInfo.showsMenuAsPrimaryAction = true
        
        let moreInfoMenu: UIMenu!
        
        if isDeletionAllowed {
           moreInfoMenu = UIMenu(title: "", image: nil,children: [deletePost])
        } else {
            moreInfoMenu = UIMenu(title: "", image: nil,children: [unfollowUser])
        }
    
        moreInfo.menu = moreInfoMenu
    }
    
    private func confirmDeletion() {
        self.delegate?.confirmDeletion(sender: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        
        [profilePhoto,userNameLabel,moreInfo,post,likesButton,commentButton ,caption,postCreatedTime,saveButton].forEach {
            postContainer.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            postContainer.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 6),
            postContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            postContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            postContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            profilePhoto.topAnchor.constraint(equalTo: postContainer.topAnchor,constant: 4),
            profilePhoto.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 12),
            profilePhoto.heightAnchor.constraint(equalToConstant: 40),
            profilePhoto.widthAnchor.constraint(equalToConstant: 40),
            
            moreInfo.topAnchor.constraint(equalTo: postContainer.topAnchor,constant: 10),
            moreInfo.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor,constant: -12),
            moreInfo.heightAnchor.constraint(equalToConstant: 30),
            moreInfo.widthAnchor.constraint(equalToConstant: 30),
            
            userNameLabel.topAnchor.constraint(equalTo: postContainer.topAnchor,constant: 4),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: moreInfo.leadingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            post.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 8),
            post.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 12),
            post.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor,constant: -12),
            post.heightAnchor.constraint(equalToConstant: 350),
            
            likesButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant:12),
            likesButton.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor),
            likesButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant:12),
            commentButton.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor,constant: 4),

            saveButton.trailingAnchor.constraint(equalTo: post.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 12),
            
            caption.topAnchor.constraint(equalTo: likesButton.bottomAnchor,constant: 8),
            caption.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 15),
            caption.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor),
            
            postCreatedTime.topAnchor.constraint(equalTo: caption.bottomAnchor,constant: 8),
            postCreatedTime.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 15),
            postCreatedTime.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor,constant: -8),
            postCreatedTime.bottomAnchor.constraint(equalTo: postContainer.bottomAnchor,constant: -10)
        ])
    }
}




