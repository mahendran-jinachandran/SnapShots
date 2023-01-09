//
//  BottomSheetsTableViewCell.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/01/23.
//

import UIKit

class BottomSheetsTableViewCell: UITableViewCell {
    
    static let identifier = "BottomSheetsTableViewCell"
    
    private lazy var imageIcon: UIImageView = {
       let imageIcon = UIImageView(frame: .zero)
       imageIcon.clipsToBounds = true
       imageIcon.contentMode = .scaleAspectFill
       imageIcon.translatesAutoresizingMaskIntoConstraints = false
       imageIcon.isUserInteractionEnabled = true
       return imageIcon
    }()
    
    private lazy var option: UILabel = {
        var option = UILabel()
        option.translatesAutoresizingMaskIntoConstraints = false
        option.text = "Mahendran"
        option.font = UIFont.systemFont(ofSize:15)
        option.isUserInteractionEnabled = true
        return option
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
           
        contentView.backgroundColor = UIColor(named: "BottomSheetBG")
        setupConstraint()
      //  imageIcon.layer.cornerRadius = 30/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(icon: UIImage,optionName: String) {
        imageIcon.image = icon
        option.text = optionName
    }
    
    private func setupConstraint() {
        
        [imageIcon,option].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            imageIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            imageIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageIcon.heightAnchor.constraint(equalToConstant: 30),
            imageIcon.widthAnchor.constraint(equalToConstant: 30),
            
            option.centerYAnchor.constraint(equalTo: imageIcon.centerYAnchor),
            option.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor,constant: 8),
        ])
    }
}

