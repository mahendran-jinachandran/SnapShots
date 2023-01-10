//
//  ListCollectionCustomCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 10/01/23.
//

import UIKit

protocol ListCollectionCustomCellDelegate: AnyObject {
    func openPost(sender: ListCollectionCustomCell)
}


class ListCollectionCustomCell: UICollectionViewCell {
    
    static let identifier = "ListCollectionCustomCell"
    weak var delegate: ListCollectionCustomCellDelegate?
    
    private lazy var postImage: UIImageView = {
        let postImage = UIImageView()
        postImage.contentMode = .scaleAspectFill
        postImage.isUserInteractionEnabled = true
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 10
        postImage.image = UIImage(systemName: "house")
        return postImage
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        [postImage].forEach { contentView.addSubview($0) }
        
        setupTapGestures()
    }
    
    func setupTapGestures() {
        postImage.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(openPost(_:)))
        )
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
