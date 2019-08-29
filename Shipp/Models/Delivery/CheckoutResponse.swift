//
//  Checkout.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 26/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import ObjectMapper

class CheckoutResponse: Codable {
    var value: Double = 0
    var distance: Double = 0
    var feeValue: Double = 0
    var totalValue: Double = 0
    
    init() {
        
    }
    
    init (value: Double, distance: Double, feeValue: Double, totalValue: Double) {
        self.value = value
        self.distance = distance
        self.feeValue = feeValue
        self.totalValue = totalValue
    }
    
    private enum CodingKeys: String, CodingKey {
        case value = "product_value"
        case distance = "distance"
        case feeValue = "fee_value"
        case totalValue = "total_value"
    }
}
