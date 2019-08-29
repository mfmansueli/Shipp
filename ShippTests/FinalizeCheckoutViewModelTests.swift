//
//  FinalizeCheckoutViewModelTests.swift
//  ShippTests
//
//  Created by Mateus Ferneda Mansueli on 29/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa

@testable import Shipp

class FinalizeCheckoutViewModelTests: XCTestCase {
    
    private var viewModel: FinalizeCheckoutViewModelType!
    var testScheduler: TestScheduler!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        viewModel = FinalizeCheckoutViewModel(provider: CheckoutDataProviderMock())
    }
    
    override func tearDown() {
        super.tearDown()
        testScheduler = nil
        viewModel = nil
    }
    
    func testWhenFinalizeCheckoutSuccess() {
        let observer = testScheduler.createObserver(CheckoutFinalizeResponse.self)
        viewModel.output.successDoFinalizeCheckout.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        viewModel.input.doFinalizeCheckout(checkout: Checkout(), creditCard: CreditCard())
        XCTAssertEqual(observer.events.count, 1)
    }
    
    func testWhenLoadCreditCardSuccess() {
        let observer = testScheduler.createObserver(CreditCard?.self)
        viewModel.output.successLoadCreditCard.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        viewModel.input.loadCreditCard()
        XCTAssertEqual(observer.events.count, 1)
    }
    
}
