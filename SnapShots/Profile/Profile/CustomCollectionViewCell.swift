//
//  CustomCollectionViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 15/11/22.
//

import UIKit

protocol CustomCollectionViewCellDelegate: AnyObject {
    func openPost(sender: CustomCollectionViewCell)
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    weak var delegate: CustomCollectionViewCellDelegate?
    
    private lazy var postImage: UIImageView = {
        let postImage = UIImageView()
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
        
        let imagePicker = UITapGestureRecognizer(target: self, action: #selector(openPost(_:)))
        postImage.addGestureRecognizer(imagePicker)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(postImage: UIImage) {
        self.postImage.image = postImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postImage.frame = CGRect(x: 0,
                                   y: 0,
                                   width: contentView.frame.size.width,
                                   height: contentView.frame.size.height)
        
    }
    
    @objc func openPost(_ sender: UITapGestureRecognizer) {
        delegate?.openPost(sender: self)
    }
}

