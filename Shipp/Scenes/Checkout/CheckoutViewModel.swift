//
//  CheckoutPresenter.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 27/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CheckoutViewModelInput {
    func doCheckout(checkout: Checkout)
}

protocol CheckoutViewModelOutput {
    var isLoading: Driver<Bool> { get }
    var error: Driver<Error> { get }
    var successDoCheckout: Driver<CheckoutResponse> { get }
    var onDataError: Driver<String> { get }
}

protocol CheckoutViewModelType {
    var input: CheckoutViewModelInput { get }
    var output: CheckoutViewModelOutput { get }
}

final class CheckoutViewModel: CheckoutViewModelType, CheckoutViewModelInput, CheckoutViewModelOutput {
    
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    let error: SharedSequence<DriverSharingStrategy, Error>
    var successDoCheckout: SharedSequence<DriverSharingStrategy, CheckoutResponse>
    var onDataError: SharedSequence<DriverSharingStrategy, String>
    
    init(provider: CheckoutDataProviderProtocol = CheckoutDataProvider()) {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        error = errorTracker.asDriver()
        isLoading = activityTracker.asDriver()
        
        successDoCheckout = doCheckoutProperty.asDriverOnErrorJustComplete()
            .flatMapLatest { checkout -> Driver<CheckoutResponse> in
                provider.doCheckout(checkout: checkout)
                    .take(1)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
        }
        
        onDataError = onDataErrorProperty.asDriverOnErrorJustComplete()
    }
    
    private let onDataErrorProperty = PublishSubject<String>()
    private let doCheckoutProperty = PublishSubject<Checkout>()
    func doCheckout(checkout: Checkout) {
        if validateForm(checkout: checkout) {
            doCheckoutProperty.onNext(checkout)
        }
    }
    
    func validateForm(checkout: Checkout) -> Bool {
        if checkout.productInfo.isEmptyString {
            onDataErrorProperty.onNext("Defina em poucas palavras o que você deseja.")
            return false
        }
        
        if checkout.value <= 0  {
            onDataErrorProperty.onNext("Informe o valor estimado da compra.")
            return false
        }
        return true
    }
    
    var input: CheckoutViewModelInput { return self }
    var output: CheckoutViewModelOutput { return self }
}
