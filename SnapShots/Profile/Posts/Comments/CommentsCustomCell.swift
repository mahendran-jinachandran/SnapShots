//
//  CommentsCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 24/11/22.
//

import UIKit

protocol CommentsCustomCellDelegate: AnyObject {
    func controller() -> CommentsVC
    func deleteComment(sender: CommentsCustomCell)
}


class CommentsCustomCell: UITableViewCell {

    static let identifier = "CommentsCustomCell"
    weak var delegate: CommentsCustomCellDelegate?
    
    private lazy var profilePhoto: UIImageView = {
       let profileImage = UIImageView(frame: .zero)
       profileImage.image = UIImage(named: "Quote")
       profileImage.clipsToBounds = true
       profileImage.contentMode = .scaleAspectFill
       profileImage.translatesAutoresizingMaskIntoConstraints = false
       profileImage.isUserInteractionEnabled = true
       return profileImage
    }()
    
    private lazy var userNameLabel: UILabel = {
       var userNameLabel = UILabel()
       userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       userNameLabel.font = UIFont.systemFont(ofSize:16)
       return userNameLabel
    }()
    
    private lazy var comment: UILabel = {
        var comment = UILabel()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.font = UIFont.systemFont(ofSize: 14)
        comment.numberOfLines = 0
        return comment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        setupContraints()
        profilePhoto.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(userDP: UIImage,username: String,comment: String,hasSpecialPermission: Bool) {
        self.profilePhoto.image = userDP
        self.userNameLabel.text = username
        self.comment.text = comment
        
        if hasSpecialPermission {
            let holdToDelete = UILongPressGestureRecognizer(target: self, action: #selector(longPressDelete(_:)))
            holdToDelete.minimumPressDuration = 1.00
            self.addGestureRecognizer(holdToDelete)
        } else {
            print("no special")
        }
    }
    
    @objc private func longPressDelete(_ sender: UILongPressGestureRecognizer) {
        
        contentView.backgroundColor = .lightGray
        
        let deleteCommentAlert = UIAlertController(title: "Delete Comment?", message: nil, preferredStyle: .alert)
        
        deleteCommentAlert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delegate?.deleteComment(sender: self)
            self.contentView.backgroundColor = .systemBackground
        })
        
        deleteCommentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.contentView.backgroundColor = .systemBackground
        })
        
        self.delegate?.controller().present(deleteCommentAlert, animated: true)
    }
    
    func setupContraints() {
        
        [profilePhoto,userNameLabel,comment].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            profilePhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            profilePhoto.widthAnchor.constraint(equalToConstant: 40),
            profilePhoto.heightAnchor.constraint(equalToConstant: 40),
        
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            comment.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 5),
            comment.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor,constant: 12),
            comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8)
            
        ])
    }
}
