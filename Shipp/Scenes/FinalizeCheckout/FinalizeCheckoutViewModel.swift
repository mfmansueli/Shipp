//
//  FinalizeFinalizeCheckoutViewModel.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FinalizeCheckoutViewModelInput {
    func doFinalizeCheckout(checkout: Checkout, creditCard: CreditCard)
    func loadCreditCard()
}

protocol FinalizeCheckoutViewModelOutput {
    var isLoading: Driver<Bool> { get }
    var error: Driver<Error> { get }
    var successDoFinalizeCheckout: Driver<CheckoutFinalizeResponse> { get }
    var successLoadCreditCard: Driver<CreditCard?> { get }
}

protocol FinalizeCheckoutViewModelType {
    var input: FinalizeCheckoutViewModelInput { get }
    var output: FinalizeCheckoutViewModelOutput { get }
}

final class FinalizeCheckoutViewModel: FinalizeCheckoutViewModelType, FinalizeCheckoutViewModelInput, FinalizeCheckoutViewModelOutput {
    
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    let error: SharedSequence<DriverSharingStrategy, Error>
    var successDoFinalizeCheckout: SharedSequence<DriverSharingStrategy, CheckoutFinalizeResponse>
    var successLoadCreditCard: SharedSequence<DriverSharingStrategy, CreditCard?>
    
    init(provider: CheckoutDataProviderProtocol = CheckoutDataProvider()) {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        error = errorTracker.asDriver()
        isLoading = activityTracker.asDriver()
        
        successDoFinalizeCheckout = doFinalizeCheckoutProperty.asDriverOnErrorJustComplete()
            .flatMapLatest { (checkout, creditCard) -> Driver<CheckoutFinalizeResponse> in
                provider.doFinalizeCheckout(checkout: checkout, creditCard: creditCard)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
        }
        
        successLoadCreditCard = loadCreditCardProperty.asDriverOnErrorJustComplete()
            .flatMapLatest { checkout -> Driver<CreditCard?> in
                provider.loadCreditCard()
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
        }
    }
    
    private let doFinalizeCheckoutProperty = PublishSubject<(Checkout, CreditCard)>()
    func doFinalizeCheckout(checkout: Checkout, creditCard: CreditCard) {
        doFinalizeCheckoutProperty.onNext((checkout, creditCard))
    }
    
    private let loadCreditCardProperty = PublishSubject<Void>()
    func loadCreditCard() {
        loadCreditCardProperty.onNext(())
    }
    
    var input: FinalizeCheckoutViewModelInput { return self }
    var output: FinalizeCheckoutViewModelOutput { return self }
}
