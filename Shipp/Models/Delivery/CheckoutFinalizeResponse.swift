//
//  CheckoutFinalizeResponse.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import ObjectMapper

class CheckoutFinalizeResponse: Codable {
    var message: String = ""
    var value: Double = 0
    
    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case value = "value"
    }
}
