//
//  UITextFieldExtensions.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/11/22.
//

import Foundation
import UIKit

extension UITextField {
    
    
//    func setImageInTextFieldOnLeft(image: UIImage,afterText: Bool = false) {
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
//        self.leftViewMode = .always
//        self.rightViewMode = .always
//        
//        if afterText {
//            imageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
//            self.setRightView(imageView, padding: 50)
//        } else {
//            imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 25)
//            self.setLeftView(imageView, padding: 10)
//        }
//      
//    }
    
    func setImageInTextFieldOnLeft(imageName: String,isSystemDefined: Bool = false) {
        let imageView: UIImageView!

        if isSystemDefined {
            imageView = UIImageView(image: UIImage(systemName: imageName))
        } else {
           imageView = UIImageView(image: UIImage(named: imageName))
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.tintColor = UIColor(named:"appTheme")
        imageView.alpha = 0.7
        self.leftViewMode = .always
        self.setLeftView(imageView, padding: 10)
    }
    
    func setLeftView(_ view: UIView, padding: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = true

        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(view)

        imageContainer.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: view.frame.size.width + padding,
                height: view.frame.size.height + padding
            )
        )

        view.center = CGPoint(
            x: imageContainer.bounds.size.width / 2,
            y: imageContainer.bounds.size.height / 2
        )

        self.leftView = imageContainer
    }
    
//    func setRightView(_ view: UIView, padding: CGFloat) {
//        view.translatesAutoresizingMaskIntoConstraints = true
//
//        let imageContainer = UIView()
//        imageContainer.translatesAutoresizingMaskIntoConstraints = false
//        imageContainer.addSubview(view)
//
//        imageContainer.frame = CGRect(
//            origin: .zero,
//            size: CGSize(
//                width: view.frame.size.width + padding,
//                height: view.frame.size.height + padding
//            )
//        )
//
//        view.center = CGPoint(
//            x: imageContainer.bounds.size.width / 2,
//            y: imageContainer.bounds.size.height / 2
//        )
//
//        self.rightView = imageContainer
//    }
}
