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
       let post = UIImageView(frame: .zero)
       post.image = UIImage(named: "Quote")
       post.clipsToBounds = true
       post.contentMode = .scaleAspectFit
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
        return comment
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(profilePhoto)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(moreInfo)
        contentView.addSubview(post)
        contentView.addSubview(like)
        contentView.addSubview(comment)
        
        setupConstraint()
        profilePhoto.layer.cornerRadius = 50/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            profilePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profilePhoto.topAnchor.constraint(equalTo: self.topAnchor),
            profilePhoto.heightAnchor.constraint(equalToConstant: 50),
            profilePhoto.widthAnchor.constraint(equalToConstant: 50),
            
            moreInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moreInfo.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            moreInfo.heightAnchor.constraint(equalToConstant: 30),
            moreInfo.widthAnchor.constraint(equalToConstant: 20),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: moreInfo.leadingAnchor),
            
            post.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 8),
            post.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            post.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            post.heightAnchor.constraint(equalToConstant: 350),
            
            like.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            like.topAnchor.constraint(equalTo: post.bottomAnchor),
            like.heightAnchor.constraint(equalToConstant: 45),
            like.widthAnchor.constraint(equalToConstant: 45),
            
            comment.leadingAnchor.constraint(equalTo: like.trailingAnchor),
            comment.topAnchor.constraint(equalTo: post.bottomAnchor),
            comment.heightAnchor.constraint(equalToConstant: 45),
            comment.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
}
