//
//  CheckoutDataProvider.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 26/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import RxSwift

protocol CheckoutDataProviderProtocol {
    func doCheckout(checkout: Checkout) -> Observable<CheckoutResponse>
    func doFinalizeCheckout(checkout: Checkout, creditCard: CreditCard) -> Observable<CheckoutFinalizeResponse>
    func saveCreditCard(creditCard: CreditCard) -> Observable<Void>
    func loadCreditCard() -> Observable<CreditCard?>
}

final class CheckoutDataProvider: CheckoutDataProviderProtocol {
    
    let apiClient: APIClient = APIClient()
    let repository = Repository<CreditCard>()
    
    func doCheckout(checkout: Checkout) -> Observable<CheckoutResponse> {
        return apiClient.requestSingle(CheckoutRouter.doCheckout(checkout: checkout),
                                       type: CheckoutResponse.self)
    }
    
    func doFinalizeCheckout(checkout: Checkout, creditCard: CreditCard) -> Observable<CheckoutFinalizeResponse> {
        return apiClient.requestSingle(CheckoutRouter.doFinalizeCheckout(checkout: checkout, creditCard: creditCard),
                                       type: CheckoutFinalizeResponse.self)
    }
    
    func saveCreditCard(creditCard: CreditCard) -> Observable<Void> {
        repository.deleteAll()
        return Observable.just(repository.save(creditCard))
    }
    
    func loadCreditCard() -> Observable<CreditCard?> {
        return Observable.just(repository.queryFirst())
    }
}
