//
//  FeedsCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 23/11/22.
//

import UIKit

class FeedsCustomCell: UITableViewCell {
    
    static let identifier = "FeedsCustomCell"
    
    public var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "Quote")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       return profileImage
    }()
    
    public lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.text = "Mahendran"
       userNameLabel.font = UIFont.systemFont(ofSize:15)
       return userNameLabel
    }()
    
    public lazy var moreInfo: UIButton = {
        var moreInfo = UIButton(type: .custom)
        moreInfo.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreInfo.translatesAutoresizingMaskIntoConstraints = false
        return moreInfo
    }()
    
    var post: UIImageView = {
       let post = UIImageView()
       post.image = UIImage(systemName: "house")
       post.clipsToBounds = true
       post.contentMode = .scaleAspectFill
       post.translatesAutoresizingMaskIntoConstraints = false
       post.isUserInteractionEnabled = true
       return post
    }()
    
    public lazy var like: UIButton = {
        var like = UIButton(type: .custom)
        let image = UIImage(systemName: "heart")?.resizedImage(Size: CGSize(width: 40, height: 30))
        like.setImage(image?.withTintColor(UIColor(named: "mainPage")!), for: .normal)
        like.translatesAutoresizingMaskIntoConstraints = false
        like.imageView?.contentMode = .scaleAspectFit
        return like
    }()
    
    public lazy var comment: UIButton = {
        var comment = UIButton(type: .custom)
        let image = UIImage(systemName: "ellipsis.message")?.resizedImage(Size: CGSize(width: 40, height: 30))
        comment.setImage(image?.withTintColor(UIColor(named: "mainPage")!), for: .normal)
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.imageView?.contentMode = .scaleAspectFit
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
        [profilePhoto,userNameLabel,moreInfo,post,like,comment,caption].forEach {
            contentView.addSubview($0)
        }
        
        setupConstraint()
        profilePhoto.layer.cornerRadius = 50/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profilePhoto.heightAnchor.constraint(equalToConstant: 40),
            profilePhoto.widthAnchor.constraint(equalToConstant: 40),
            
            moreInfo.topAnchor.constraint(equalTo: contentView.topAnchor),
            moreInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moreInfo.heightAnchor.constraint(equalToConstant: 50),
            moreInfo.widthAnchor.constraint(equalToConstant: 50),
            
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: moreInfo.leadingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            post.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 8),
            post.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            post.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            post.heightAnchor.constraint(equalToConstant: 350),
            
            like.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            like.topAnchor.constraint(equalTo: post.bottomAnchor),
            like.heightAnchor.constraint(equalToConstant: 45),
            like.widthAnchor.constraint(equalToConstant: 45),
            
            comment.leadingAnchor.constraint(equalTo: like.trailingAnchor),
            comment.topAnchor.constraint(equalTo: post.bottomAnchor),
            comment.heightAnchor.constraint(equalToConstant: 45),
            comment.widthAnchor.constraint(equalToConstant: 45),
            
            caption.topAnchor.constraint(equalTo: like.bottomAnchor,constant: 2),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            caption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20)
        ])
    }
}
