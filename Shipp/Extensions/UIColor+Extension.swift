//
//  UIColor+Extension.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 25/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

extension UIColor {
    static func hex(value: UInt32) -> UIColor {
        let red = CGFloat((value & 0xFF0000) >> 16)
        let green = CGFloat((value & 0x00FF00) >> 8)
        let blue = CGFloat(value & 0x0000FF)
        return UIColor.rgba(red, green, blue)
    }
    
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    enum App {
        static let lightSlateBlue = UIColor.hex(value: 0x6D5DFF)
        static let lightGrey = UIColor.hex(value: 0xD7D7D7)
        static let silver = UIColor.hex(value: 0xB9B8B9)
    }
}
