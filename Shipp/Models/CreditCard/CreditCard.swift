//
//  CreditCard.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

struct CreditCard {
    var number: String = ""
    var name: String = ""
    var validThru: String = ""
    var cvv: String = ""
    var type: String = ""
    
    init() {
        
    }
    
    init(number: String, name: String, validThru: String, cvv: String, type: String) {
        self.number = number
        self.name = name
        self.validThru = validThru
        self.cvv = cvv
        self.type = type
    }
}
