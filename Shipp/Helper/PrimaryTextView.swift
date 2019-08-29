//
//  PrimaryTextView.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 26/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class PrimaryTextView: UITextView, UITextViewDelegate {
    
    private struct Constants {
        static let enter: String.Element = "\n"
        static let maxHeightMessage = CGFloat(90)
        static let increaseMessageHeight = CGFloat(5)
    }
    
    var customBorderColor = UIColor.App.lightGrey.cgColor
    var customTextColor = UIColor.App.lightGrey
    var placeholder = ""
    var heightConstraint: NSLayoutConstraint?
    var isMoney = false
    var maxMoneyLenght = 11
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.delegate = self
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.borderColor = customBorderColor
        textColor = customTextColor
        if customTextColor == UIColor.App.lightGrey {
            text = placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if text.last == Constants.enter {
            textView.text.removeLast()
            return
        }
        
        if isMoney, let value = Double(textView.text.digitsOnly().safelyLimitedTo(length: maxMoneyLenght)) {
            textView.text = (value / 100).asMoney()
            return
        }
        
        guard let heightConstraint = heightConstraint else { return }
            let condition = textView.contentSize.height <=
                Constants.maxHeightMessage
            let height = textView.contentSize.height + Constants.increaseMessageHeight
            heightConstraint.constant = condition ? height : Constants.maxHeightMessage
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.App.lightGrey {
            textView.text = nil
            customTextColor = UIColor.black
            textView.textColor = UIColor.black
        }
        customBorderColor = UIColor.App.lightSlateBlue.cgColor
        textView.layer.borderColor = UIColor.App.lightSlateBlue.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            customTextColor = UIColor.App.lightGrey
            textView.textColor = UIColor.App.lightGrey
        }
        customBorderColor = UIColor.App.lightGrey.cgColor
        textView.layer.borderColor = UIColor.App.lightGrey.cgColor
    }
}
