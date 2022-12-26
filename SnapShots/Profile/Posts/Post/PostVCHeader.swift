//
//  PostVCHeader.swift
//  SnapShots
//
//  Created by mahendran-14703 on 26/12/22.
//

import UIKit

protocol PostVCHeaderDelegate: AnyObject {
    func likeThePost(sender: PostVCHeader)
    func unLikeThePost(sender: PostVCHeader)
    func showComments()
}

class PostVCHeader: UITableViewHeaderFooterView {

    static let identifier = "PostVCHeader"
    weak var delegate: PostVCHeaderDelegate?
    private var likeFlag: Bool!
    
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
     //   button.tintColor = UIColor(named: "appTheme")!
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

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .systemBackground
        setupConstraint()
        setupTapGestures()
        profilePhoto.layer.cornerRadius = 40/2
        moreInfo.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(profilePhoto: UIImage,username: String,postPhoto: UIImage,caption: String,postCreatedTime: String,likeCount: Int,commentsCount: Int,isAlreadyLiked: Bool) {
        
        self.profilePhoto.image = profilePhoto
        self.userNameLabel.text = username
        self.post.image = postPhoto
        self.caption.text = caption
        self.postCreatedTime.text = postCreatedTime
        self.likesButton.setTitle(String( Double(likeCount).shortStringRepresentation ), for: .normal)
        self.commentButton.setTitle(String( Double(commentsCount).shortStringRepresentation), for: .normal)
        self.likeFlag = isAlreadyLiked
        setLikeHeartImage(isLiked: likeFlag)
    }
    
    private func setupTapGestures() {
        likesButton.addTarget(self, action: #selector(reactToThePost(_:)), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(goToComments), for: .touchUpInside)
      //  moreInfo.addTarget(self, action: #selector(showOwnerMenu(_:)), for: .touchUpInside)

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
            likesButton.tintColor = UIColor(named: "appTheme")!
        }
    }
    
    @objc private func goToComments() {
        delegate?.showComments()
    }
    
    private func setupConstraint() {
        
        [profilePhoto,userNameLabel,moreInfo,post,likesButton,commentButton ,caption,postCreatedTime].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4),
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            profilePhoto.heightAnchor.constraint(equalToConstant: 40),
            profilePhoto.widthAnchor.constraint(equalToConstant: 40),
            
            moreInfo.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            moreInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            moreInfo.heightAnchor.constraint(equalToConstant: 30),
            moreInfo.widthAnchor.constraint(equalToConstant: 30),
            
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: moreInfo.leadingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            post.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 8),
            post.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            post.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            post.heightAnchor.constraint(equalToConstant: 350),
            
            likesButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant:12),
            likesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            likesButton.widthAnchor.constraint(equalToConstant: 100),
            likesButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant:12),
            commentButton.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor,constant: 15),
            commentButton.widthAnchor.constraint(equalToConstant: 100),
            commentButton.heightAnchor.constraint(equalToConstant: 30),
            
            caption.topAnchor.constraint(equalTo: likesButton.bottomAnchor,constant: 8),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            postCreatedTime.topAnchor.constraint(equalTo: caption.bottomAnchor,constant: 8),
            postCreatedTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            postCreatedTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            postCreatedTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
    }
    
}
