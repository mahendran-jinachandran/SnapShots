//
//  UIButtonExtension.swift
//  SnapShots
//
//  Created by mahendran-14703 on 14/12/22.
//

import UIKit

class CustomButton : UIButton
{
    private var selectColour: UIColor
    private var deselectColour: UIColor
    init(selectColour: UIColor,deselectColour: UIColor) {
        self.selectColour = selectColour
        self.deselectColour = deselectColour
        super.init(frame: .zero)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet
        {
            backgroundColor = isHighlighted ? selectColour.withAlphaComponent(0.7) : deselectColour
        }
    }
}
