//
//  LikesCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

class LikesCustomCell: UITableViewCell {
    
    static let identifier = "LikesCustomCell"
    
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
       userNameLabel.text = "MahendranMahendranqw"
       userNameLabel.font = UIFont.systemFont(ofSize:16)
       return userNameLabel
    }()
    
    public lazy var followButton: UIButton = {
        var followButton = UIButton()
        followButton.setTitle("Follow", for: .normal)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.backgroundColor = .systemBlue
        followButton.layer.cornerRadius = 5
        followButton.setTitleColor(.black, for: .normal)
        return followButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        
        [profilePhoto,userNameLabel,followButton].forEach {
            contentView.addSubview($0)
        }
        
        setupConstraint()
        profilePhoto.layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 60),
            profilePhoto.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            followButton.widthAnchor.constraint(equalToConstant: 100),
            followButton.heightAnchor.constraint(equalToConstant: 30),
            followButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor)
            
        ])
    }
    
}
