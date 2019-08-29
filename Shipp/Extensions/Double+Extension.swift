//
//  Double+Extension.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 27/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import Foundation

extension Double {
    func asMoney() -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.currencyDecimalSeparator = ","
        numberFormatter.groupingSeparator = "."
        numberFormatter.positivePrefix = "R$ "
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: self as NSNumber) ?? ""
    }
}
