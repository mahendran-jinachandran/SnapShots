//
//  PostViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class PostVC: UIViewController {

    var postImage: UIImage
    var postDetails: Post
    
    let scrollView: UIScrollView = {
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
    
    public var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "house")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
        profileImage.backgroundColor = .red
       return profileImage
    }()
    
    public lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.font = UIFont.systemFont(ofSize:17)
        userNameLabel.text = "mahendran"
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
       post.image = UIImage(named: "house")
       post.contentMode = .scaleAspectFill
       post.translatesAutoresizingMaskIntoConstraints = false
       post.isUserInteractionEnabled = true
       post.layer.cornerRadius = 15
        post.backgroundColor = .blue
       return post
    }()
    
    public lazy var caption: UILabel = {
       var caption = UILabel()
       caption.translatesAutoresizingMaskIntoConstraints = false
       caption.text = "User: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
       caption.font = UIFont.systemFont(ofSize:15)
       caption.numberOfLines = 10
        caption.backgroundColor = .systemGray
       return caption
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
    
    init(postImage: UIImage,postDetails: Post) {
        self.postImage = postImage
        self.postDetails = postDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Posts"
        setupNavigationItems()
        setupConstraints()
        
        profilePhoto.layer.cornerRadius = 40/2
        moreInfo.layer.cornerRadius = 15
    }
    
    func setupNavigationItems() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(goBack))
        
        navigationController?.navigationBar.tintColor = UIColor(named: "appTheme")
    }
    
    func setupConstraints() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)
        
        [profilePhoto,userNameLabel,moreInfo,post,like,comment,caption].forEach {
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
            
            comment.leadingAnchor.constraint(equalTo: like.trailingAnchor,constant: 10),
            comment.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 6),
            comment.heightAnchor.constraint(equalToConstant: 30),
            comment.widthAnchor.constraint(equalToConstant: 35),
            
            caption.topAnchor.constraint(equalTo: like.bottomAnchor),
            caption.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor,constant: 12),
            caption.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor,constant: -12),
            caption.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor)
        ])
        
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func goToLikes() {
       // self.navigationController?.pushViewController(LikesVC(), animated: true)
    }
    
    @objc func gotToComments() {
      //  self.navigationController?.pushViewController(CommentsVC(), animated: true)
    }
    
    @objc func showOwnerMenu(_ sender: UIButton) {
    
        let moreInfo = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let allLikes = UIAlertAction(title: "All Likes", style: .default) { _ in
            self.goToLikes()
        }

        let edit = UIAlertAction(title: "Edit", style: .default) { _ in
        }

        let deletePost = UIAlertAction(title: "Delete", style: .default) { _ in
            self.confirmDeletion()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)

        moreInfo.addAction(allLikes)
        moreInfo.addAction(edit)
        moreInfo.addAction(deletePost)
        moreInfo.addAction(cancel)
        
        present(moreInfo, animated: true)
    }
    
    func confirmDeletion() {
        
        let confirmDeletion = UIAlertController(title: "Confirm Delete?", message: "You won't be able to retrieve it later.", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Delete", style: .destructive) { _ in
            PostControls().deletePost(postID: self.postDetails.postID)
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmDeletion.addAction(confirm)
        confirmDeletion.addAction(cancel)
        
        present(confirmDeletion, animated: true)
        
    }
}
