//
//  SearchCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 23/11/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"
    
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
    
    public lazy var deletebutton: UIButton = {
        var deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setContentHuggingPriority(.init(249), for: .horizontal)
        return deleteButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        contentView.addSubview(profilePhoto)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(deletebutton)
        
        setupConstraint()
        profilePhoto.layer.cornerRadius = 50/2
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            profilePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            profilePhoto.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profilePhoto.heightAnchor.constraint(equalToConstant: 50),
            profilePhoto.widthAnchor.constraint(equalToConstant: 50),
            
            deletebutton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            deletebutton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deletebutton.heightAnchor.constraint(equalToConstant: 13),
            deletebutton.widthAnchor.constraint(equalToConstant: 13),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: deletebutton.leadingAnchor)
        
        ])
    }
}
