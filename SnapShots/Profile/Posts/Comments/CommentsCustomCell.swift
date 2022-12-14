//
//  CommentsCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class CommentsCustomCell: UITableViewCell {

  static let identifier = "CommentsCustomCell"
    
    private lazy var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "Quote")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       return profileImage
    }()
    
    private lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.font = UIFont.systemFont(ofSize:16)
       return userNameLabel
    }()
    
    private lazy var comment: UILabel = {
        var comment = UILabel()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.font = UIFont.systemFont(ofSize: 14)
        comment.numberOfLines = 0
        return comment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContraints()
        profilePhoto.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(userDP: UIImage,username: String,comment: String) {
        self.profilePhoto.image = userDP
        self.userNameLabel.text = username
        self.comment.text = comment
    }
    
    func setupContraints() {
        
        [profilePhoto,userNameLabel,comment].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            profilePhoto.widthAnchor.constraint(equalToConstant: 40),
            profilePhoto.heightAnchor.constraint(equalToConstant: 40),
        
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            comment.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 5),
            comment.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8)
            
        ])
    }
}
