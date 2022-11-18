//
//  CustomTableViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 16/11/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"
    
    private var profilePhoto: UIImageView = {
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
       userNameLabel.font = UIFont.systemFont(ofSize:15)
       return userNameLabel
    }()
    
    private lazy var acceptButton: UIButton = {
        let acceptButton = UIButton()
        acceptButton.setTitle("CONFIRM", for: .normal)
        acceptButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        acceptButton.backgroundColor = .systemBlue
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.layer.cornerRadius = 5.0
        acceptButton.setTitleColor( .systemBackground, for: .normal)
        return acceptButton
    }()
    
    private lazy var rejectButton: UIButton = {
        let rejectButton = UIButton()
        rejectButton.setTitle("DELETE", for: .normal)
        rejectButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rejectButton.backgroundColor = UIColor(named: "deleteButton")
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        rejectButton.layer.cornerRadius = 5.0
        rejectButton.setTitleColor( UIColor(named: "mainPage") , for: .normal)
        return rejectButton
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profilePhoto)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(rejectButton)
        
        setupConstraint()
        profilePhoto.layer.cornerRadius = 50 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupConstraint() {

        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            profilePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            profilePhoto.heightAnchor.constraint(equalToConstant: 50),
            profilePhoto.widthAnchor.constraint(equalToConstant: 50),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            userNameLabel.centerXAnchor.constraint(equalTo: profilePhoto.centerXAnchor,constant: 77),
            
            rejectButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
            rejectButton.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            rejectButton.heightAnchor.constraint(equalToConstant: 30),
            rejectButton.widthAnchor.constraint(equalToConstant: 60),
            
            acceptButton.trailingAnchor.constraint(equalTo: rejectButton.trailingAnchor,constant: -75),
            acceptButton.topAnchor.constraint(equalTo: self.topAnchor,constant: 15),
            acceptButton.heightAnchor.constraint(equalToConstant: 30),
            acceptButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
