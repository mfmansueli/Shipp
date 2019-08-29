//
//  CreditCardType.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//
import UIKit

enum CreditCardType: String {
    case  Visa, MasterCard, Unknown
    
    static let allCards = [Visa, MasterCard]
    
    var regex: String {
        get {
            switch self {
            case .Visa:
                return "^^4\\d{0,}$"
            case .MasterCard:
                return "^(5[1-5][0-9]{1}|677189)[0-9]{5,}$"
            default:
                return ""
            }
        }
        set {
        }
    }
    
    var flag: UIImage? {
        get {
            switch self {
            case .Visa:
                return #imageLiteral(resourceName: "iconVisa")
            case .MasterCard:
                return #imageLiteral(resourceName: "iconMaster")
            default:
                return #imageLiteral(resourceName: "iconCard")
            }
        }
        set {
        }
    }
}
