//
//  ListTableViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/01/23.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"
    
    private lazy var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
        profileImage.image = UIImage(systemName: "house")
       return profileImage
    }()
    
    private lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
        userNameLabel.text = "Test"
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.font = UIFont.systemFont(ofSize:16)
       return userNameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraint()
        profilePhoto.layer.cornerRadius = 30
    }
    
    func configure(profilePhoto: UIImage,userNameLabel: String) {
        self.profilePhoto.image = profilePhoto
        self.userNameLabel.text = userNameLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        
        [profilePhoto,userNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            profilePhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            profilePhoto.widthAnchor.constraint(equalToConstant: 60),
            profilePhoto.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
}
