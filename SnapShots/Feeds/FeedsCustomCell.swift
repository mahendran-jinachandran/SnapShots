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
    func isDeletionAllowed(sender: FeedsCustomCell) -> Bool
    func deletePost(sender: FeedsCustomCell)
    func goToProfile(sender: FeedsCustomCell)
}

class FeedsCustomCell: UITableViewCell {
    
    static let identifier = "FeedsCustomCell"
    private var likeFlag: Bool = false
    weak var delegate: FeedsCustomCellDelegate?
    
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
    
    private lazy var caption: UILabel = {
        var caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.font = UIFont.systemFont(ofSize:15)
        caption.numberOfLines = 0
        return caption
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
    
    func configure(profilePhoto: UIImage,username: String,postPhoto: UIImage,postCaption: String,isAlreadyLiked: Bool,likedUsersCount: Int,commentedUsersCount: Int) {
        
        self.profilePhoto.image = profilePhoto
        self.userNameLabel.text = username
        self.post.image = postPhoto
        self.caption.text = postCaption
        self.likeFlag = isAlreadyLiked
        self.likesCount.text = String( Double(likedUsersCount).shortStringRepresentation )
        self.commentsCount.text = String( Double(commentedUsersCount).shortStringRepresentation)
        setLikeHeartImage(isLiked: likeFlag)
    }
    
    private func setupButtonTargets() {
        like.addTarget(self, action: #selector(reactToThePost(_:)), for: .touchUpInside)
        moreInfo.addTarget(self, action: #selector(showOwnerMenu(_:)), for: .touchUpInside)
        comment.addTarget(self, action: #selector(gotToComments), for: .touchUpInside)
        
        let profilePhotoTap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        profilePhoto.addGestureRecognizer(profilePhotoTap)
        
        let usernameTap = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        userNameLabel.addGestureRecognizer(usernameTap)
    }
    
    @objc private func reactToThePost(_ sender : UITapGestureRecognizer) {
        likeFlag = !likeFlag
        
        if likeFlag {
            setLikeHeartImage(isLiked: likeFlag)
            likesCount.text = String( Int(likesCount.text!)! + 1)
            delegate?.likeThePost(sender: self)
        } else {
            setLikeHeartImage(isLiked: likeFlag)
            likesCount.text = String( Int(likesCount.text!)! - 1)
            delegate?.unLikeThePost(sender: self)
        }
    }
        
    private func setLikeHeartImage(isLiked: Bool) {
        if isLiked {
            like.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            like.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
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
    
    @objc private func showOwnerMenu(_ sender: UIButton) {
        
        let moreInfo = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let allLikes = UIAlertAction(title: "All Likes", style: .default) { _ in
            self.goToLikes()
        }
        moreInfo.addAction(allLikes)
        
        if (delegate?.isDeletionAllowed(sender: self)) == true {
            let deletePost = UIAlertAction(title: "Delete", style: .default) { _ in
                self.confirmDeletion()
            }
            moreInfo.addAction(deletePost)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        moreInfo.addAction(cancel)
        
        delegate?.controller().present(moreInfo, animated: true)
        
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
        
        [profilePhoto,userNameLabel,moreInfo,post,like,likesCount,comment,commentsCount ,caption].forEach {
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
            
            like.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 12),
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
            caption.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 12),
            caption.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor),
            caption.bottomAnchor.constraint(equalTo: postContainer.bottomAnchor,constant: -8)
        ])
    }
}


extension Double {
    var shortStringRepresentation: String {
        if self.isNaN {
            return "NaN"
        }
        if self.isInfinite {
            return "\(self < 0.0 ? "-" : "+")Infinity"
        }
        
        if self == 0 {
            return "0"
        }
        
        let units = ["", "k", "M"]
        var interval = self
        var i = 0
        while i < units.count - 1 {
            if abs(interval) < 1000.0 {
                break
            }
            i += 1
            interval /= 1000.0
        }

        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 2, interval))\(units[i])"
    }
}

