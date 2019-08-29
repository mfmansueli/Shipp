//
//  SecondaryTextField.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class SecondaryTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    var leftPlaceHolder: UILabel!
    var leftPlaceHolderText: String = ""
    var customBorderColor: UIColor = UIColor.App.lightGrey {
        didSet {
            layer.masksToBounds = false
            layer.shadowColor = customBorderColor.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 0.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderStyle = .none
        backgroundColor = .white
        textAlignment = .right
        
        layer.masksToBounds = false
        layer.shadowColor = customBorderColor.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        
        font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if leftPlaceHolder == nil {
            leftPlaceHolder = UILabel(frame: CGRect(x: 16, y: 0, width: 150, height: 35))
            leftPlaceHolder.text = leftPlaceHolderText
            leftPlaceHolder.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            leftView = leftPlaceHolder
            leftViewMode = .always
            return
        }
        leftPlaceHolder.text = leftPlaceHolderText
        
        addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
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
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        customBorderColor = UIColor.App.lightSlateBlue
    }
    
    @objc func textFieldDidEndEditing(_ textView: UITextView) {
        customBorderColor = UIColor.App.lightGrey
    }
}
