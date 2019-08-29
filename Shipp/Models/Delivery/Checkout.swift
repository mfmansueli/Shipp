//
//  Checkout.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 26/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import IGListKit

class Checkout: NSObject {
    var productInfo: String = ""
    var value: Double = 0
    var storeName: String? = ""
    var location: String? = ""
    var storeLatitude: Double = 0
    var storeLongitude: Double = 0
    var userLatitude: Double = 0
    var userLongitude: Double = 0
    var creditCardNumber: String = ""
    var distance: Double = 0
    var feeValue: Double = 0
    var totalValue: Double = 0
    
    override init() {
        
    }
    
    init(storeName: String?,
         location: String?,
         storeLatitude: Double,
         storeLongitude: Double,
         userLatitude: Double,
         userLongitude: Double) {
        self.storeName = storeName
        self.location = location
        self.storeLatitude = storeLatitude
        self.storeLongitude = storeLongitude
        self.userLatitude = userLatitude
        self.userLongitude = userLongitude
    }
    
}

extension Checkout: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object ? true : self.isEqual(object)
    }
}
