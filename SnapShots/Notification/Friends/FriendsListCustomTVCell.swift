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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        setupConstraint()
        profilePhoto.layer.cornerRadius = 50 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(userDP: UIImage,username: String) {
        profilePhoto.image = userDP
        userNameLabel.text = username
    }
    
    private func setupConstraint() {
        
        [profilePhoto,userNameLabel].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            profilePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            profilePhoto.heightAnchor.constraint(equalToConstant: 50),
            profilePhoto.widthAnchor.constraint(equalToConstant: 50),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.centerXAnchor,constant: 40),
        ])
    }
}
