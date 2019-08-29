//
//  PrimaryButton.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 26/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    
    var customBackgroundColor = UIColor.App.lightGrey
    var customTitleColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = customBackgroundColor
        setTitleColor(customTitleColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        layer.cornerRadius = 8
    }
    
    override var isEnabled: Bool {
        didSet {
            customBackgroundColor = isEnabled ? UIColor.App.lightSlateBlue : UIColor.App.lightGrey
            backgroundColor = customBackgroundColor
        }
    }
}
