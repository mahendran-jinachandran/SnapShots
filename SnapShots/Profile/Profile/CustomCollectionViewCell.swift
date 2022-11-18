//
//  CustomCollectionViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 15/11/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    private let myImageView: UIImageView = {
        let myImage = UIImageView()
        myImage.image = UIImage(systemName: "house")
        myImage.contentMode = .scaleAspectFit
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
        
        myImageView.frame = CGRect(x: 5,
                                   y: 20,
                                   width: contentView.frame.size.width - 10,
                                   height: contentView.frame.size.height - 50)
    }
}

