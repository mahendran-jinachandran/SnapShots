//
//  PostVCHeader.swift
//  SnapShots
//
//  Created by mahendran-14703 on 26/12/22.
//

import UIKit

protocol PostVCHeaderDelegate: AnyObject {
    func popAViewController()
    func confirmDeletion()
    func likeThePost()
    func unLikeThePost()
    func displayAllLikesUsers()
    func openCommentBox()
    func unfollowUser()
    func hideLikesCount()
    func unhideLikesCount()
    func hideComments()
    func unhideComments()
    func archiveThePost()
    func unarchiveThePost()
    func addPostToSaved()
    func removePostFromSaved()
}

class PostVCHeader: UITableViewHeaderFooterView {

    static let identifier = "PostVCHeader"
    weak var delegate: PostVCHeaderDelegate?
    private var likeFlag: Bool!
    private var isSaved: Bool = false
    
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
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
 
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        var configButton = UIButton.Configuration.borderless()
        configButton.imagePadding = 6
                
        let button = UIButton(configuration: configButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis.message"), for: .normal)
        button.tintColor = UIColor(named: "appTheme")!

        return button
    }()
    
    private lazy var viewAllLikes: UILabel = {
        var viewAllLikes = UILabel()
        viewAllLikes.translatesAutoresizingMaskIntoConstraints = false
        viewAllLikes.font = UIFont.systemFont(ofSize:17)
        viewAllLikes.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        viewAllLikes.isUserInteractionEnabled = true
        return viewAllLikes
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
    
    var withViewLikes = [NSLayoutConstraint]()
    var withoutViewLikes = [NSLayoutConstraint]()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .systemBackground
        setupConstraint()
        setupTapGestures()
        setupViewLikesConstraints()
        profilePhoto.layer.cornerRadius = 40/2
        moreInfo.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(profilePhoto: UIImage,username: String,postPhoto: UIImage,caption: String,postCreatedTime: String,likeCount: Int,commentsCount: Int,isAlreadyLiked: Bool,isDeletionAllowed: Bool,isLikesCountHidden: Bool,isCommentsHidden: Bool,isArchived: Bool,isSaved: Bool) {
        
        self.profilePhoto.image = profilePhoto
        self.userNameLabel.text = username
        self.post.image = postPhoto
        self.caption.text = caption
        self.postCreatedTime.text = postCreatedTime
        self.likeFlag = isAlreadyLiked
        self.isSaved = isSaved
        
        setLikeHeartImage(isLiked: likeFlag)
        setSavedCollectionImage(isSaved: isSaved)
        
        setupLikes(isLikesCountHidden: isLikesCountHidden, likeCount: likeCount)
        changeLikesButtonState(isLikesCountHidden: isLikesCountHidden, likeCount: likeCount)
        changeCommentButtonState(isCommentsHidden: isCommentsHidden)
        setupMoreInfoButtonActions(isDeletionAllowed: isDeletionAllowed,isLikesCountHidden: isLikesCountHidden,isCommentsHidden: isCommentsHidden,isArchived: isArchived)
    }
    
    private func changeLikesButtonState(isLikesCountHidden: Bool,likeCount: Int) {
        if isLikesCountHidden {
            likesButton.titleLabel?.layer.opacity = 0.0
        } else {
            self.likesButton.setTitle(String( Double(likeCount).shortStringRepresentation ), for: .normal)
            likesButton.titleLabel?.layer.opacity = 1.0
        }
    }
    
    private func changeCommentButtonState(isCommentsHidden: Bool) {
        if isCommentsHidden {
            commentButton.isHidden = true
        } else {
            commentButton.isHidden = false
        }
    }
    
    private func setupLikes(isLikesCountHidden: Bool,likeCount: Int) {
        
        if !isLikesCountHidden && likeCount > 0 {
            self.viewAllLikes.text = "View \(Double(likeCount).shortStringRepresentation) Likes"
            NSLayoutConstraint.deactivate(withoutViewLikes)
            NSLayoutConstraint.activate(withViewLikes)

        } else {
            self.viewAllLikes.text = "View 0 Likes"
            NSLayoutConstraint.deactivate(withViewLikes)
            NSLayoutConstraint.activate(withoutViewLikes)
        }
        
        layoutIfNeeded()
    }

    func setupViewLikesConstraints() {
        
         withViewLikes = [
            viewAllLikes.topAnchor.constraint(equalTo: likesButton.bottomAnchor,constant: 4),
            viewAllLikes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            viewAllLikes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            caption.topAnchor.constraint(equalTo: viewAllLikes.bottomAnchor,constant: 28),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            postCreatedTime.topAnchor.constraint(equalTo: caption.bottomAnchor,constant: 4),
            postCreatedTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            postCreatedTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            postCreatedTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
         ]
        
        withoutViewLikes = [
            
            caption.topAnchor.constraint(equalTo: likesButton.bottomAnchor,constant: 8),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            postCreatedTime.topAnchor.constraint(equalTo: caption.bottomAnchor,constant: 4),
            postCreatedTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            postCreatedTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            postCreatedTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ]
    }
    
    private func setupTapGestures() {
        likesButton.addTarget(self, action: #selector(reactToThePost(_:)), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(goToComments), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(savePost), for: .touchUpInside)
        
        viewAllLikes.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getAllLikedUsers)))
    }
    
    @objc private func savePost() {
        
        isSaved = !isSaved
        setSavedCollectionImage(isSaved: isSaved)
        if isSaved {
            delegate?.addPostToSaved()
        } else {
            delegate?.removePostFromSaved()
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

        if likeFlag {
            setLikeHeartImage(isLiked: likeFlag)
            self.likesButton.setTitle(
                String( Int((self.likesButton.titleLabel?.text!)!)! + 1),
                for: .normal)
    
            delegate?.likeThePost()
        } else {
            setLikeHeartImage(isLiked: likeFlag)
            self.likesButton.setTitle(
                String( Int((self.likesButton.titleLabel?.text!)!)! - 1),
                for: .normal)
            
            delegate?.unLikeThePost()
        }
        
                //NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
    }
    
    private func setLikeHeartImage(isLiked: Bool) {
       
        UIView.animate(withDuration: 0.2, animations: {
            
            let image = isLiked ? UIImage(systemName: "suit.heart.fill") : UIImage(systemName: "suit.heart")
            let imageColour = isLiked ? UIColor.red : UIColor(named: "appTheme")
            let newscale = isLiked ? 1.3 : 0.7
            self.likesButton.transform = self.likesButton.transform.scaledBy(x: newscale, y: newscale)
            self.likesButton.setImage(image, for: .normal)
            self.likesButton.tintColor = imageColour
        },completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.likesButton.transform = CGAffineTransform.identity
            })
        })
    }
    
    @objc private func goToComments() {
        delegate?.openCommentBox()
    }
    
    func setupMoreInfoButtonActions(isDeletionAllowed: Bool,isLikesCountHidden: Bool,isCommentsHidden: Bool,isArchived: Bool) {
        
        let deletePost = UIAction(
          title: "Delete",
          image: UIImage(systemName: "trash"),
          attributes: .destructive) { _ in
              
            self.confirmDeletion()
        }
        
        let unfollowUser = UIAction(
          title: "Unfollow User",
          image: UIImage(systemName: "person.badge.minus")) { _ in
              
              self.delegate?.unfollowUser()
           //   NotificationCenter.default.post(name: Constants.publishPostEvent, object: nil)
           //   NotificationCenter.default.post(name: Constants.userDetailsEvent, object: nil)
              // MARK: CHECK
              self.delegate?.popAViewController()
        }
        
        var likesCountVisibility: UIAction
        var commentsVisibility: UIAction
        var archivedAction: UIAction
        
        if !isArchived {
            archivedAction = UIAction(title: "Archive", image: UIImage(systemName: "archivebox.fill")) { _ in
                
                self.delegate?.archiveThePost()
                self.delegate?.popAViewController()
            }
        } else {
            archivedAction = UIAction(title: "Unarchive", image: UIImage(systemName: "archivebox.fill")) { _ in
                
                self.delegate?.unarchiveThePost()
                self.delegate?.popAViewController()
            }
        }
        
        if isLikesCountHidden {
            likesCountVisibility = UIAction(
                title: "Unhide likes count",
                image: UIImage(systemName: "heart")) { _ in
                  
                    self.delegate?.unhideLikesCount()
            }
        } else {
            likesCountVisibility =  UIAction(
                title: "Hide likes count",
                image: UIImage(systemName: "heart.slash")) { _ in
                
                    self.delegate?.hideLikesCount()
            }
        }
        
        if isCommentsHidden {
            commentsVisibility = UIAction(
                title: "Unhide comments",
                image: UIImage(systemName: "pencil")) { _ in
                
                    self.delegate?.unhideComments()
                 }
        } else {
            commentsVisibility = UIAction(
                title: "Hide comments",
                image: UIImage(systemName: "pencil.slash")) { _ in
                
                    self.delegate?.hideComments()
            }
        }
        
        moreInfo.showsMenuAsPrimaryAction = true
        
        let moreInfoMenu: UIMenu!
        
        if isDeletionAllowed {
           moreInfoMenu = UIMenu(title: "", image: nil,children: [likesCountVisibility,commentsVisibility,archivedAction,deletePost])
        } else {
            moreInfoMenu = UIMenu(title: "", image: nil,children: [unfollowUser])
        }
    
        moreInfo.menu = moreInfoMenu
    }
    
    private func confirmDeletion() {
        self.delegate?.confirmDeletion()
    }
    
    @objc func getAllLikedUsers() {
        delegate?.displayAllLikesUsers()
    }
    
    private func setupConstraint() {
        
        [profilePhoto,userNameLabel,moreInfo,post,likesButton,commentButton,saveButton,viewAllLikes,caption,postCreatedTime].forEach {
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
            likesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            likesButton.heightAnchor.constraint(equalToConstant: 30),
            
            commentButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant:12),
            commentButton.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor,constant: 4),
           
            saveButton.trailingAnchor.constraint(equalTo: post.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 12),
            
            viewAllLikes.topAnchor.constraint(equalTo: likesButton.bottomAnchor,constant: 4),
            viewAllLikes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            viewAllLikes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            caption.topAnchor.constraint(equalTo: viewAllLikes.bottomAnchor,constant: 8),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            postCreatedTime.topAnchor.constraint(equalTo: caption.bottomAnchor,constant: 4),
            postCreatedTime.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            postCreatedTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            postCreatedTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
    }
}
