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
}

class FeedsCustomCell: UITableViewCell {
    
    static let identifier = "FeedsCustomCell"
    private var likeFlag: Bool = false
    weak var delegate: FeedsCustomCellDelegate?
    private var postUserID: Int!
    
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
    
    public var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       return profileImage
    }()
    
    public lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.font = UIFont.systemFont(ofSize:17)
       return userNameLabel
    }()
    
    public lazy var moreInfo: UIButton = {
        var moreInfo = UIButton(type: .custom)
        moreInfo.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreInfo.translatesAutoresizingMaskIntoConstraints = false
        moreInfo.tintColor = UIColor(named: "appTheme")
        moreInfo.backgroundColor = UIColor(named: "moreInfo_bg_color")
        return moreInfo
    }()
    
    var post: UIImageView = {
       let post = UIImageView()
       post.clipsToBounds = true
       post.contentMode = .scaleAspectFill
       post.translatesAutoresizingMaskIntoConstraints = false
       post.isUserInteractionEnabled = true
       post.layer.cornerRadius = 15
       return post
    }()
    
    public lazy var like: UIButton = {
        var like = UIButton()
        like.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        like.translatesAutoresizingMaskIntoConstraints = false
        like.contentMode = .scaleAspectFill
        like.isUserInteractionEnabled = true
        like.tintColor = .red
        return like
    }()
    
    public lazy var comment: UIButton = {
        var comment = UIButton()
        comment.setBackgroundImage(UIImage(systemName: "ellipsis.message"), for: .normal)
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.contentMode = .scaleAspectFill
        comment.isUserInteractionEnabled = true
        return comment
    }()
    
    public lazy var caption: UILabel = {
       var caption = UILabel()
       caption.translatesAutoresizingMaskIntoConstraints = false
       caption.text = "User: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
       caption.font = UIFont.systemFont(ofSize:15)
       caption.numberOfLines = 10
       return caption
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(postContainer)
        
        [profilePhoto,userNameLabel,moreInfo,post,like,comment,caption].forEach {
            postContainer.addSubview($0)
        }
        
        setupConstraint()
        setupButtonTargets()
        profilePhoto.layer.cornerRadius = 40/2
        moreInfo.layer.cornerRadius = 15
    }
    
    func configure(postUserID: Int,profilePhoto: UIImage,username: String,postPhoto: UIImage,postCaption: String,isAlreadyLiked: Bool) {
        self.postUserID = postUserID
        self.profilePhoto.image = profilePhoto
        self.userNameLabel.text = username
        self.post.image = postPhoto
        self.caption.text = postCaption
        self.likeFlag = isAlreadyLiked
        setLikeHeartImage(isLiked: likeFlag)
    }
    
    func setupButtonTargets() {
        like.addTarget(self, action: #selector(reactToThePost(_:)), for: .touchUpInside)
        moreInfo.addTarget(self, action: #selector(showOwnerMenu(_:)), for: .touchUpInside)
        comment.addTarget(self, action: #selector(gotToComments), for: .touchUpInside)
    }
    
    @objc func reactToThePost(_ sender : UITapGestureRecognizer) {
        likeFlag = !likeFlag
        
        if likeFlag {
            setLikeHeartImage(isLiked: likeFlag)
            delegate?.likeThePost(sender: self)
        } else {
            setLikeHeartImage(isLiked: likeFlag)
            delegate?.unLikeThePost(sender: self)
        }
    }
    
    func setLikeHeartImage(isLiked: Bool) {
        if isLiked {
            like.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            like.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc func goToLikes() {
        delegate?.showLikes(sender: self)
    }
    
    @objc func gotToComments() {
        delegate?.showComments(sender: self)
    }
    
    @objc func showOwnerMenu(_ sender: UIButton) {
    
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
    
    func confirmDeletion() {
        let confirmDeletion = UIAlertController(title: "Confirm Delete?", message: "You won't be able to retrieve it later.", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delegate?.controller().navigationController?.popViewController(animated: true)
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
            
            comment.leadingAnchor.constraint(equalTo: like.trailingAnchor,constant: 10),
            comment.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 6),
            comment.heightAnchor.constraint(equalToConstant: 30),
            comment.widthAnchor.constraint(equalToConstant: 35),
            
            caption.topAnchor.constraint(equalTo: like.bottomAnchor,constant: 8),
            caption.leadingAnchor.constraint(equalTo: postContainer.leadingAnchor,constant: 12),
            caption.trailingAnchor.constraint(equalTo: postContainer.trailingAnchor),
            caption.bottomAnchor.constraint(equalTo: postContainer.bottomAnchor,constant: -8)
        ])
    }
}
