//
//  CustomCollectionViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 15/11/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    var postImage: UIImageView = {
        let postImage = UIImageView()
        postImage.image = UIImage(systemName: "house")
        postImage.contentMode = .scaleAspectFill
        postImage.isUserInteractionEnabled = true
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 10
        return postImage
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        [postImage].forEach { contentView.addSubview($0) }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postImage.frame = CGRect(x: 0,
                                   y: 0,
                                   width: contentView.frame.size.width,
                                   height: contentView.frame.size.height)
        
    }
}

