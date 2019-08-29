//
//  CheckoutDataProviderMock.swift
//  ShippTests
//
//  Created by Mateus Ferneda Mansueli on 29/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import RxSwift

@testable import Shipp

final class CheckoutDataProviderMock: CheckoutDataProviderProtocol {
    func doCheckout(checkout: Checkout) -> Observable<CheckoutResponse> {
        return Observable.just(CheckoutResponse())
    }
    
    func doFinalizeCheckout(checkout: Checkout, creditCard: CreditCard) -> Observable<CheckoutFinalizeResponse> {
        return Observable.just(CheckoutFinalizeResponse())
    }
    
    func saveCreditCard(creditCard: CreditCard) -> Observable<Void> {
        return Observable.just(())
    }
    
    func loadCreditCard() -> Observable<CreditCard?> {
        return Observable.just(CreditCard())
    }
}
