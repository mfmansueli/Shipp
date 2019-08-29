//
//  PrimaryTextField.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 25/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class PrimaryTextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderStyle = .none
        layer.borderWidth = 1
        layer.borderColor = UIColor.App.lightGrey.cgColor
        layer.cornerRadius = 8
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
