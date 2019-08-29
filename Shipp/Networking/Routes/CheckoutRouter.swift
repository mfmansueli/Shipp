//
//  DeliveryRouter.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 26/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum CheckoutRouter {
    case doCheckout(checkout: Checkout)
    case doFinalizeCheckout(checkout: Checkout, creditCard: CreditCard)
}

extension CheckoutRouter: RouterType {
    
    var path: String {
        switch self {
        case .doCheckout:
            return "https://d9eqa4nu35.execute-api.sa-east-1.amazonaws.com/evaluate"
        case .doFinalizeCheckout:
            return "https://mdk3ljy26k.execute-api.sa-east-1.amazonaws.com/order"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .doCheckout(let checkout):
            return ["store_latitude": checkout.storeLatitude,
                    "store_longitude" : checkout.storeLongitude,
                    "user_latitude": checkout.userLatitude,
                    "user_longitude": checkout.userLongitude,
                    "value": checkout.value]
        case .doFinalizeCheckout(let checkout, let creditCard):
            return ["store_latitude": checkout.storeLatitude,
                    "store_longitude" : checkout.storeLongitude,
                    "user_latitude" : checkout.userLatitude,
                    "user_longitude" : checkout.userLongitude,
                    "card_number" : creditCard.number,
                    "cvv" : creditCard.cvv,
                    "expiry_date" : creditCard.validThru,
                    "value" : checkout.value]
        }
    }
}
