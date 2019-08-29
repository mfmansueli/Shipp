//
//  TitleLabel.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 24/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        numberOfLines = 0
        textColor = .black
        font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
}
