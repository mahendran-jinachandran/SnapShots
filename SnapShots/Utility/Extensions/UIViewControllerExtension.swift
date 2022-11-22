//
//  UIViewControllerExtension.swift
//  SnapShots
//
//  Created by mahendran-14703 on 21/11/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func generateCell(leftImage: UIImageView,label: UILabel,rightImage: UIImageView) -> UIView {
        
        let customCell = UIView()
        view.addSubview(customCell)

        customCell.translatesAutoresizingMaskIntoConstraints = false
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        customCell.heightAnchor.constraint(equalToConstant: 50).isActive = true
     //   customCell.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        [leftImage,label,rightImage].forEach {
            customCell.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            leftImage.leadingAnchor.constraint(equalTo: customCell.leadingAnchor,constant: 10),
            leftImage.topAnchor.constraint(equalTo: customCell.topAnchor,constant: 10),
            leftImage.widthAnchor.constraint(equalToConstant: 20),
            leftImage.heightAnchor.constraint(equalToConstant: 20),
            
            rightImage.topAnchor.constraint(equalTo: customCell.topAnchor,constant: 10),
            rightImage.trailingAnchor.constraint(equalTo: customCell.trailingAnchor,constant: -10),
            leftImage.widthAnchor.constraint(equalToConstant: 30),
            leftImage.heightAnchor.constraint(equalToConstant: 30),
            
            label.topAnchor.constraint(equalTo: customCell.topAnchor,constant: 10),
            label.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor,constant: 10),
            label.trailingAnchor.constraint(equalTo: rightImage.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: customCell.bottomAnchor,constant: -10)
            
        ])
        
        return customCell
    }
}
