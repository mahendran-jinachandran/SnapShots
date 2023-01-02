//
//  FeedsCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 23/11/22.
//

import UIKit

protocol FeedsCustomCellDelegate: AnyObject {
    func controller() -> FeedsVC
    func likeThePost(sender: FeedsCustomCell)
    func unLikeThePost(sender: FeedsCustomCell)
    func showLikes(sender: FeedsCustomCell)
    func showComments(sender: FeedsCustomCell)
    func deletePost(sender: FeedsCustomCell)
    func goToProfile(sender: FeedsCustomCell)
    func unfollowUser(sender: FeedsCustomCell)
}

class FeedsCustomCell: UITableViewCell {
    
    static let identifier = "FeedsCustomCell"
    private var likeFlag: Bool = false
    weak var delegate: FeedsCustomCellDelegate?
    private var isDeletionAllowed: Bool = false
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(postContainer)
        
        setupConstraint()
        setupButtonTargets()
        profilePhoto.layer.cornerRadius = 40/2
        moreInfo.layer.cornerRadius = 15
  
    }
    
    func configure(profilePhoto: UIImage,username: String,postPhoto: UIImage,postCaption: String,isAlreadyLiked: Bool,likedUsersCount: Int,commentedUsersCount: Int,postCreatedTime: String,isDeletionAllowed: Bool) {
        
        self.profilePhoto.image = profilePhoto
        self.userNameLabel.text = username
        self.post.image = postPhoto
        self.caption.text = postCaption
        self.likeFlag = isAlreadyLiked
        
        self.likesButton.setTitle(String( Double(likedUsersCount).shortStringRepresentation ), for: .normal)
        self.commentButton.setTitle(String( Double(commentedUsersCount).shortStringRepresentation), for: .normal)
            
        self.postCreatedTime.text = String(AppUtility.getDate(date: postCreatedTime))
        
        setLikeHeartImage(isLiked: likeFlag)
        setupMoreInfoButtonActions(isDeletionAllowed: isDeletionAllowed)
    }
    
    private func setupButtonTargets() {
        likesButton.addTarget(self, action: #selector(reactToThePost(_:)), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(gotToComments), for: .touchUpInside)
        
        let profilePhotoTap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        profilePhoto.addGestureRecognizer(profilePhotoTap)
        
        let usernameTap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        userNameLabel.addGestureRecognizer(usernameTap)
    }
    
    @objc private func reactToThePost(_ sender : UITapGestureRecognizer) {
        likeFlag = !likeFlag

        if likeFlag {
            setLikeHeartImage(isLiked: likeFlag)
            self.likesButton.setTitle(
                String( Int((self.likesButton.titleLabel?.text!)!)! + 1),
                for: .normal)
            
            delegate?.likeThePost(sender: self)
        } else {
            setLikeHeartImage(isLiked: likeFlag)
            self.likesButton.setTitle(
                String( Int((self.likesButton.titleLabel?.text!)!)! - 1),
                for: .normal)
            delegate?.unLikeThePost(sender: self)
        }
    }
        
    private func setLikeHeartImage(isLiked: Bool) {
        if isLiked {
            likesButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            likesButton.tintColor = .red
        } else {
            likesButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            likesButton.tintColor = UIColor(named: "appTheme")
        }
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
              NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
              self.delegate?.controller().navigationController?.popViewController(animated: true)
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
        let confirmDeletion = UIAlertController(title: "Confirm Delete?", message: "You won't be able to retrieve it later.", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delegate?.deletePost(sender: self)
            NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmDeletion.addAction(confirm)
        confirmDeletion.addAction(cancel)
        
        delegate?.controller().present(confirmDeletion, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        
        [profilePhoto,userNameLabel,moreInfo,post,likesButton,commentButton ,caption,postCreatedTime].forEach {
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
            likesButton.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: -24),
            likesButton.widthAnchor.constraint(equalToConstant: 150),
            likesButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant:12),
            commentButton.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor,constant: -24),
            commentButton.widthAnchor.constraint(equalToConstant: 100),
            commentButton.heightAnchor.constraint(equalToConstant: 30),
            
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




