//
//  RMCreditCard.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import RealmSwift

final class RMCreditCard: Object {
    
    @objc dynamic var number: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var validThru: String = ""
    @objc dynamic var cvv: String = ""
    @objc dynamic var type: String = ""
    
    override static func primaryKey() -> String? { return "number" }
}

extension RMCreditCard: DomainConvertibleType {
    func asDomain() -> CreditCard {
        var object = CreditCard()
        object.number = number
        object.name = name
        object.validThru = validThru
        object.cvv = cvv
        object.type = type
        return object
    }
}

extension CreditCard: RealmRepresentable {
    var uid: String {
        return "\(number)"
    }
    
    func asRealm() -> RMCreditCard {
        var object = RMCreditCard()
        object.number = number
        object.name = name
        object.validThru = validThru
        object.cvv = cvv
        object.type = type
        return object
    }
}
