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
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        self.view.window!.layer.add(transition, forKey: kCATransition)

        navigationController?.pushViewController(viewControllerToPresent, animated: true)
    }

//    func dismissDetail() {
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//
//        navigationController?.popViewController(animated: false)
//    }
}
