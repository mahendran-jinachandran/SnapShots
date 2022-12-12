//
//  CustomTableViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

class FriendsListCustomTVCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"
    
    
    private lazy var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "blankPhoto")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       return profileImage
    }()
    
    private lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.text = "Mahendran"
       userNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
       return userNameLabel
    }()
    
    private lazy var followUser: UIButton = {
        let acceptButton = UIButton()
        acceptButton.setTitle("Follow", for: .normal)
        acceptButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        acceptButton.backgroundColor = UIColor(named: "post_bg_color")
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.layer.cornerRadius = 5.0
        acceptButton.setTitleColor( UIColor(named: "appTheme"), for: .normal)
        return acceptButton
    }()
    
    private lazy var unfollowUser: UIButton = {
        let rejectButton = UIButton()
        rejectButton.setTitle("Following", for: .normal)
        rejectButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rejectButton.backgroundColor = UIColor(named: "post_bg_color")
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        rejectButton.layer.cornerRadius = 5.0
        rejectButton.setTitleColor( UIColor(named: "appTheme") , for: .normal)
        return rejectButton
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        
        setupConstraint()
        setupTapGestures()
        profilePhoto.layer.cornerRadius = 50 / 2

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTapGestures() {
        followUser.addTarget(self, action: #selector(addToFriends), for: .touchUpInside)
        unfollowUser.addTarget(self, action: #selector(removeFromFriends), for: .touchUpInside)
    }
    
    func configure(userDP: UIImage,username: String) {
        profilePhoto.image = userDP
        userNameLabel.text = username
    }
    
    @objc private func addToFriends() {
        unfollowUser.isHidden = false
        followUser.isHidden = true
    }
        
    @objc private func removeFromFriends() {
        unfollowUser.isHidden = true
        followUser.isHidden = false
    }
    
    private func setupConstraint() {
        
        [profilePhoto,userNameLabel,followUser,unfollowUser].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            profilePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            profilePhoto.heightAnchor.constraint(equalToConstant: 50),
            profilePhoto.widthAnchor.constraint(equalToConstant: 50),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            userNameLabel.centerXAnchor.constraint(equalTo: profilePhoto.centerXAnchor,constant: 57),
            
            followUser.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
            followUser.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            followUser.heightAnchor.constraint(equalToConstant: 30),
            followUser.widthAnchor.constraint(equalToConstant: 70),
            
            unfollowUser.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
            unfollowUser.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            unfollowUser.heightAnchor.constraint(equalToConstant: 30),
            unfollowUser.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
