//
//  ProfileFooterCollectionResuableView.swift
//  SnapShots
//
//  Created by mahendran-14703 on 05/12/22.
//

import UIKit

class ProfileFooterCollectionResuableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private lazy var postsLabel: UILabel = {
        var postsLabel = UILabel()
        postsLabel.translatesAutoresizingMaskIntoConstraints = false
        postsLabel.font = UIFont.boldSystemFont(ofSize: 25)
        postsLabel.textAlignment = .center
        postsLabel.textColor = .gray
        return postsLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [postsLabel].forEach {
            self.addSubview($0)
        }
        
        setupConstraints()
    }
    
    func configure(profileAccessibility: ProfileAccess) {
        
        if profileAccessibility == .blocked {
            postsLabel.text = "Blocked Account"
        } else if profileAccessibility == .friend || profileAccessibility == .owner {
            postsLabel.text = "No Posts yet"
        } else {
            postsLabel.text =  "Private Account"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            postsLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 8),
            postsLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -8),
            postsLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 8),
            postsLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -8),
        ])
    }
}
