//
//  UITextFieldExtensions.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/11/22.
//

import Foundation
import UIKit

extension UITextField {
    
    func setImageInTextFieldOnLeft(imageName: String) {
        let imageView = UIImageView(image: UIImage(named: imageName)?.withTintColor(UIColor(named: "mainPage")!))
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
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
}
