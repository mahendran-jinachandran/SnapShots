//
//  CommentsCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class CommentsCustomCell: UITableViewCell {

    static let identifier = "CommentsCustomCell"
    
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
       userNameLabel.font = UIFont.systemFont(ofSize:16)
       return userNameLabel
    }()
    
    public lazy var comment: UILabel = {
        var comment = UILabel()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.text = "AmazingAmazingAmazingAmazingAmazingAmazingAmazingAmazingAmazingAmazingAmazing"
        comment.font = UIFont.systemFont(ofSize: 14)
        comment.numberOfLines = 0
        return comment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [profilePhoto,userNameLabel,comment].forEach {
            contentView.addSubview($0)
        }
        
        setupContraints()
        profilePhoto.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var bottomConstraint: NSLayoutConstraint!
    
    func configure(comment: String?) {
        
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 40),
            profilePhoto.heightAnchor.constraint(equalToConstant: 40),
//            profilePhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
        
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            comment.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 5),
            comment.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -30)
            
        
        ])
    }
    
}
