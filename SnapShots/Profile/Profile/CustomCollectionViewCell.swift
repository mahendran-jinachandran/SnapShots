//
//  CustomCollectionViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 15/11/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    var myImageView: UIImageView = {
        let myImage = UIImageView()
        myImage.image = UIImage(systemName: "house")
        myImage.contentMode = .scaleAspectFill
        return myImage
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
        contentView.clipsToBounds = true
        [myImageView].forEach { contentView.addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myImageView.frame = CGRect(x: 0,
                                   y: 0,
                                   width: contentView.frame.size.width,
                                   height: contentView.frame.size.height)
    }
}

