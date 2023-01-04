//
//  NotificiationGridCVCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 25/11/22.
//

import UIKit

protocol NotificiationGridCVCellDelegate: AnyObject {
    func acceptFriendRequest(sender: NotificiationGridCVCell)
    func rejectFriendRequest(sender: NotificiationGridCVCell)
}

class NotificiationGridCVCell: UICollectionViewCell {
    
    static let identifier = "NotificiationGridCVCell"
    weak var notificationGridVCCellDelegate: NotificiationGridCVCellDelegate?
    
    private lazy var requestContainer: UIView = {
        let requestContainer = UIView()
        requestContainer.translatesAutoresizingMaskIntoConstraints = false
        requestContainer.clipsToBounds = true
        requestContainer.layer.cornerRadius = 10
        requestContainer.layer.borderWidth = 1
        requestContainer.layer.borderColor = UIColor.gray.cgColor        
        requestContainer.backgroundColor = UIColor(named: "post_bg_color")
        return requestContainer
    }()
    
    private lazy var profilePhoto: UIImageView = {
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
       userNameLabel.text = "MahendranMahendranMahendran"
       userNameLabel.font = UIFont.systemFont(ofSize:17)
       return userNameLabel
    }()
    
    public lazy var acceptRequest: CustomButton = {
        let acceptRequest = CustomButton(selectColour: .systemBlue, deselectColour: .systemBlue)
        acceptRequest.translatesAutoresizingMaskIntoConstraints = false
        acceptRequest.setTitle("Accept", for: .normal)
        acceptRequest.clipsToBounds = true
        acceptRequest.backgroundColor = .systemBlue
        acceptRequest.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        acceptRequest.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        return acceptRequest
    }()
    
    public lazy var rejectRequest: CustomButton = {
        let rejectRequest = CustomButton(selectColour: UIColor(named: "moreInfo_bg_color")!, deselectColour: UIColor(named: "moreInfo_bg_color")!)
        rejectRequest.translatesAutoresizingMaskIntoConstraints = false
        rejectRequest.clipsToBounds = true
        rejectRequest.backgroundColor = UIColor(named: "moreInfo_bg_color")
        rejectRequest.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rejectRequest.setTitle("Reject", for: .normal)
        rejectRequest.setTitleColor(UIColor(named: "appTheme"), for: .normal)
        return rejectRequest
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setConstraints()
        setupTapGestures()
        
        profilePhoto.layer.cornerRadius = 30
        acceptRequest.layer.cornerRadius = 13
        rejectRequest.layer.cornerRadius = 13
    }
    
    func setupTapGestures() {
        acceptRequest.addTarget(self, action: #selector(acceptingUser), for: .touchUpInside)
        rejectRequest.addTarget(self, action: #selector(rejectingUser), for: .touchUpInside)
    }
    
    @objc func acceptingUser()  {
        notificationGridVCCellDelegate?.acceptFriendRequest(sender: self)
    }
    
    @objc func rejectingUser() {
        notificationGridVCCellDelegate?.rejectFriendRequest(sender: self)
    }
    
    func configure(username: String,userDP: UIImage) {
        userNameLabel.text = username
        profilePhoto.image = userDP
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        
        contentView.addSubview(requestContainer)
        
        [profilePhoto,userNameLabel,acceptRequest,rejectRequest].forEach{
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            requestContainer.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4),
            requestContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            requestContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                      constant: -8),
            requestContainer.heightAnchor.constraint(equalToConstant: 160),
       //     requestContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            profilePhoto.topAnchor.constraint(equalTo: requestContainer.topAnchor,constant: 8),
            profilePhoto.centerXAnchor.constraint(equalTo: requestContainer.centerXAnchor),
            profilePhoto.heightAnchor.constraint(equalToConstant: 60),
            profilePhoto.widthAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor,constant: 12),
            userNameLabel.centerXAnchor.constraint(equalTo: requestContainer.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: requestContainer.leadingAnchor,constant: 4),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: requestContainer.trailingAnchor,constant: -4),
            
            acceptRequest.leadingAnchor.constraint(equalTo: requestContainer.leadingAnchor,constant: 6),
            acceptRequest.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 8),
            acceptRequest.heightAnchor.constraint(equalToConstant: 35),
            acceptRequest.widthAnchor.constraint(equalTo: requestContainer.widthAnchor, multiplier: 0.45),
            acceptRequest.trailingAnchor.constraint(equalTo: requestContainer.trailingAnchor),
            
            rejectRequest.leadingAnchor.constraint(equalTo: acceptRequest.trailingAnchor),
            rejectRequest.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 8),
            rejectRequest.heightAnchor.constraint(equalToConstant: 35),
            rejectRequest.widthAnchor.constraint(equalTo: requestContainer.widthAnchor, multiplier: 0.45),
            rejectRequest.trailingAnchor.constraint(equalTo: requestContainer.trailingAnchor, constant: -6),
            
        ])
    }
}
