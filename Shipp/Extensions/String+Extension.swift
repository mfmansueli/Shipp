//
//  String+Extension.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 27/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import Foundation

extension String {
    
    func digitsOnly() -> String{
        return String(filter { "0"..."9" ~= $0 })
    }
    
    func safelyLimitedTo(length n: Int) -> String {
        guard n >= 0, self.count > n else {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    var isEmptyString: Bool {
        let text = self.trimmingCharacters(in: .whitespaces)
        if text.isEmpty {
            return true
        }
        
        return false
    }
    
    func isValidCreditCard() -> (type: CreditCardType, valid: Bool) {
        var valid = false
        var type: CreditCardType = .Unknown
        for card in CreditCardType.allCards {
            if matchesRegex(regex: card.regex, text: self) {
                type = card
                valid = validateCard(number: self)
                break
            }
        }
        return (type, valid)
    }
    
    func isValidExpirationDate() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let today = Date()
        if let date = dateFormatter.date(from: self), date.compare(today) == .orderedDescending {
            return true
        }
        return false
    }
    
    func matchesRegex(regex: String, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func validateCard(number: String) -> Bool {
        let numbers = number.digitsOnly()
        if numbers.count < 9 {
            return false
        }
        
        var reversedString = ""
        let range: Range<String.Index> = numbers.startIndex..<numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [.reverse, .byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        
        for (i, s) in reversedString.enumerated() {
            
            let digit = Int(String(s))!
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }

}
