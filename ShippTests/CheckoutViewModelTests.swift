//
//  CheckoutViewModelTests.swift
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

class CheckoutViewModelTests: XCTestCase {
    
    private var viewModel: CheckoutViewModelType!
    var testScheduler: TestScheduler!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        viewModel = CheckoutViewModel(provider: CheckoutDataProviderMock())
    }
    
    override func tearDown() {
        super.tearDown()
        testScheduler = nil
        viewModel = nil
    }
    
    func testWhenProductInfoIsEmpty() {
        let checkout = Checkout()
        checkout.productInfo = ""
        let observer = testScheduler.createObserver(String.self)
        viewModel.output.onDataError.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        let events = [
            next(0, "Defina em poucas palavras o que você deseja.")
        ]
        viewModel.input.doCheckout(checkout: checkout)
        XCTAssertEqual(observer.events, events)
    }
    
    func testWhenEstimatedValueIsEmpty() {
        let checkout = Checkout()
        checkout.productInfo = "Teste"
        checkout.value = 0
        let observer = testScheduler.createObserver(String.self)
        viewModel.output.onDataError.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        let events = [
            next(0, "Informe o valor estimado da compra.")
        ]
        viewModel.input.doCheckout(checkout: checkout)
        XCTAssertEqual(observer.events, events)
    }
    
    
    func testWhenDoCheckoutSuccess() {
        let checkout = Checkout()
        checkout.productInfo = "Teste"
        checkout.value = 50
        let observer = testScheduler.createObserver(CheckoutResponse.self)
        viewModel.output.successDoCheckout.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        viewModel.input.doCheckout(checkout: checkout)
        XCTAssertEqual(observer.events.count, 1)
    }
    
}
