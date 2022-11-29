//
//  SuggestionCVCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 25/11/22.
//

import UIKit

class SuggestionCVCell: UICollectionViewCell {
    
    static let identifier = "SuggestionCVCell"
    
    private lazy var profileContainer: UIView = {
       var postContainer = UIView()
       postContainer.translatesAutoresizingMaskIntoConstraints = false
        postContainer.clipsToBounds = true
        postContainer.layer.cornerRadius = 15
        postContainer.layer.borderWidth = 0.5
        postContainer.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        postContainer.backgroundColor = UIColor(named: "post_bg_color")
       return postContainer
    }()
    
    private var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "blankPhoto")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = 10.0
       return profileImage
    }()
    
    public lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.text = "Mahendran"
       userNameLabel.font = UIFont.systemFont(ofSize:15)
       return userNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(profileContainer)
        
        [profilePhoto,userNameLabel].forEach {
            profileContainer.addSubview($0)
        }
     
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            profileContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 2),
            profileContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -2),
            profileContainer.heightAnchor.constraint(equalToConstant: 200),
            
            profilePhoto.topAnchor.constraint(equalTo: profileContainer.topAnchor,constant: 12),
            profilePhoto.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor,constant: 18),
            profilePhoto.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor,constant: -18),
            profilePhoto.heightAnchor.constraint(equalToConstant: 150),
            
            userNameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor),
            userNameLabel.centerXAnchor.constraint(equalTo: profilePhoto.centerXAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
