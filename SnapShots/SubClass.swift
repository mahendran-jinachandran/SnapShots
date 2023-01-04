//
//  SubClass.swift
//  SnapShots
//
//  Created by mahendran-14703 on 15/12/22.
//

import UIKit

class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender)
        return false
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRectZero
    }
}

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
