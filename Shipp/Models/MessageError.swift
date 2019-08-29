//
//  MessageError.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 29/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import ObjectMapper

class MessageError: Codable {
    var message: String = ""
    
    init() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
