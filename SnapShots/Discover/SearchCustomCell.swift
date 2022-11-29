//
//  SearchCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 23/11/22.
//

import UIKit

protocol SearchPeopleVCDelegate: AnyObject {
    func removeFromRecentSearches(_ sender: UIButton)
}

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"
    
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
       userNameLabel.isUserInteractionEnabled = true
       return userNameLabel
    }()
    
    private lazy var deletebutton: UIButton = {
        var deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    weak var searchPeopleVCDelegate: SearchPeopleVCDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.systemBackground
        
        [profilePhoto,userNameLabel,deletebutton].forEach {
            contentView.addSubview($0)
        }
                
        setupConstraint()
        profilePhoto.layer.cornerRadius = 50/2
        deletebutton.addTarget(self, action: #selector(removeFromRecentSearch(_:)), for: .touchUpInside)
    }
    
    func configure(userName: String,userDP: UIImage) {
        userNameLabel.text = userName
        profilePhoto.image = userDP
    }
    
    @objc func removeFromRecentSearch(_ sender : UIButton) {
       searchPeopleVCDelegate?.removeFromRecentSearches(sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            profilePhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePhoto.heightAnchor.constraint(equalToConstant: 50),
            profilePhoto.widthAnchor.constraint(equalToConstant: 50),
            
            deletebutton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            deletebutton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deletebutton.heightAnchor.constraint(equalToConstant: 13),
            deletebutton.widthAnchor.constraint(equalToConstant: 13),
            
            userNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: deletebutton.leadingAnchor)
        
        ])
    }
}
