//
//  AddCardViewModel.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddCardViewModelInput {
    func saveCreditCard(number: String?, name: String?,
                       validThru: String?, cvv: String?)
}

protocol AddCardViewModelOutput {
    var isLoading: Driver<Bool> { get }
    var error: Driver<Error> { get }
    var successAddCard: Driver<Void> { get }
    var onDataError: Driver<String> { get }
}

protocol AddCardViewModelType {
    var input: AddCardViewModelInput { get }
    var output: AddCardViewModelOutput { get }
}

final class AddCardViewModel: AddCardViewModelType, AddCardViewModelInput, AddCardViewModelOutput {
    
    let isLoading: SharedSequence<DriverSharingStrategy, Bool>
    let error: SharedSequence<DriverSharingStrategy, Error>
    var successAddCard: SharedSequence<DriverSharingStrategy, Void>
    var onDataError: SharedSequence<DriverSharingStrategy, String>
    
    init(provider: CheckoutDataProviderProtocol = CheckoutDataProvider()) {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker()
        
        error = errorTracker.asDriver()
        isLoading = activityTracker.asDriver()
        
        successAddCard = doSaveCreditCardProperty.asDriverOnErrorJustComplete()
            .flatMapLatest { creditCard -> Driver<Void> in
                provider.saveCreditCard(creditCard: creditCard)
                    .trackActivity(activityTracker)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
        }
        
        onDataError = onDataErrorProperty.asDriverOnErrorJustComplete()
    }
    
    private let onDataErrorProperty = PublishSubject<String>()
    private let doSaveCreditCardProperty = PublishSubject<CreditCard>()
    func saveCreditCard(number: String?, name: String?,
                        validThru: String?, cvv: String?) {
        if let creditCard = validateForm(number: number, name: name,
                                         validThru: validThru, cvv: cvv) {
            doSaveCreditCardProperty.onNext(creditCard)
        }
    }
    
    func validateForm(number: String?, name: String?,
                      validThru: String?, cvv: String?) -> CreditCard? {
        
        guard let number = number?.digitsOnly(), number.count == 16 else {
            onDataErrorProperty.onNext("Informe um número de cartão válido")
            return nil
        }
        
        guard let name = name, !name.isEmptyString else {
            onDataErrorProperty.onNext("Dê um nome para o seu cartão")
            return nil
        }
        
        guard let validThru = validThru, validThru.isValidExpirationDate() else {
            onDataErrorProperty.onNext("Data de validade do cartão inválida")
            return nil
        }
        
        guard let cvv = cvv, cvv.count == 3 else {
            onDataErrorProperty.onNext("Informe o CVV do cartão")
            return nil
        }
        
        return CreditCard(number: number, name: name, validThru: validThru, cvv: cvv, type: number.isValidCreditCard().type.rawValue)
    }
    
    var input: AddCardViewModelInput { return self }
    var output: AddCardViewModelOutput { return self }
}
