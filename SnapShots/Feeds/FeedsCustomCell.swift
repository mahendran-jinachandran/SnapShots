//
//  FeedsCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 23/11/22.
//

import UIKit

class FeedsCustomCell: UITableViewCell {
    
    static let identifier = "FeedsCustomCell"
    
    private var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "blankPhoto")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       profileImage.setContentHuggingPriority(.init(249), for: .horizontal)
       return profileImage
    }()
    
    public lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.text = "Mahendran"
       userNameLabel.font = UIFont.systemFont(ofSize:15)
       userNameLabel.setContentHuggingPriority(.init(249), for: .horizontal)
       return userNameLabel
    }()
    
    public lazy var moreInfo: UIButton = {
        var moreInfo = UIButton(type: .custom)
        moreInfo.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreInfo.translatesAutoresizingMaskIntoConstraints = false
        moreInfo.setContentHuggingPriority(.init(249), for: .horizontal)
        moreInfo.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        return moreInfo
    }()
    
    private var post: UIImageView = {
       let post = UIImageView(frame: .zero)
       post.image = UIImage(named: "blankPhoto")
       post.clipsToBounds = true
       post.contentMode = .scaleAspectFill
       post.translatesAutoresizingMaskIntoConstraints = false
       post.isUserInteractionEnabled = true
       post.setContentHuggingPriority(.init(249), for: .horizontal)
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(profilePhoto)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(moreInfo)
        contentView.addSubview(post)
        contentView.addSubview(like)
        
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
            moreInfo.heightAnchor.constraint(equalToConstant: 20),
            moreInfo.widthAnchor.constraint(equalToConstant: 20),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: moreInfo.leadingAnchor),
            
            post.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 8),
            post.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            post.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            post.heightAnchor.constraint(equalToConstant: 350),
            
            like.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            like.topAnchor.constraint(equalTo: post.bottomAnchor,constant: 8),
            like.heightAnchor.constraint(equalToConstant: 50),
            like.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

extension UIImage
{
   
}
