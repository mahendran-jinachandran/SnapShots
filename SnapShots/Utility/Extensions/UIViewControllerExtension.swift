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
        customCell.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        [leftImage,label,rightImage].forEach {
            customCell.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            leftImage.leadingAnchor.constraint(equalTo: customCell.leadingAnchor,constant: 10),
            leftImage.topAnchor.constraint(equalTo: customCell.topAnchor,constant: 5),
            leftImage.widthAnchor.constraint(equalToConstant: 26),
            leftImage.heightAnchor.constraint(equalToConstant: 26),
            
            rightImage.topAnchor.constraint(equalTo: customCell.topAnchor,constant: 5),
            rightImage.trailingAnchor.constraint(equalTo: customCell.trailingAnchor,constant: -10),
            leftImage.widthAnchor.constraint(equalToConstant: 30),
            leftImage.heightAnchor.constraint(equalToConstant: 36),
            
            label.topAnchor.constraint(equalTo: customCell.topAnchor,constant: 5),
            label.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor,constant: 10),
            label.trailingAnchor.constraint(equalTo: rightImage.leadingAnchor),
            label.heightAnchor.constraint(equalToConstant: 26)
            
        ])
        
        return customCell
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-50, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.lightGray
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
    
