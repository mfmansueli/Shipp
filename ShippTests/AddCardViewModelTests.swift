//
//  AddCardViewModelTests.swift
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

class AddCardViewModelTests: XCTestCase {
    
    private var viewModel: AddCardViewModelType!
    var testScheduler: TestScheduler!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        viewModel = AddCardViewModel(provider: CheckoutDataProviderMock())
    }
    
    override func tearDown() {
        super.tearDown()
        testScheduler = nil
        viewModel = nil
    }
    
    func testWhenCreditCardIsEmpty() {
        let observer = testScheduler.createObserver(String.self)
        viewModel.output.onDataError.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        let events = [
            next(0, "Informe um número de cartão válido")
        ]
        viewModel.input.saveCreditCard(number: "", name: "", validThru: "", cvv: "")
        XCTAssertEqual(observer.events, events)
    }
    
    func testWhenCreditCardNameIsEmpty() {
        let observer = testScheduler.createObserver(String.self)
        viewModel.output.onDataError.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        let events = [
            next(0, "Dê um nome para o seu cartão")
        ]
        viewModel.input.saveCreditCard(number: "5136 0025 3796 3755", name: "", validThru: "", cvv: "")
        XCTAssertEqual(observer.events, events)
    }
    
    func testWhenCreditCardValidThruIsEmpty() {
        let observer = testScheduler.createObserver(String.self)
        viewModel.output.onDataError.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        let events = [
            next(0, "Data de validade do cartão inválida")
        ]
        viewModel.input.saveCreditCard(number: "5136 0025 3796 3755", name: "Teste", validThru: "", cvv: "")
        XCTAssertEqual(observer.events, events)
    }
    
    func testWhenCreditCarCVVIsEmpty() {
        let observer = testScheduler.createObserver(String.self)
        viewModel.output.onDataError.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        let events = [
            next(0, "Informe o CVV do cartão")
        ]
        viewModel.input.saveCreditCard(number: "5136 0025 3796 3755", name: "Teste", validThru: "03/20", cvv: "")
        XCTAssertEqual(observer.events, events)
    }
    
    func testWhenSaveCreditCardSuccess() {
        let observer = testScheduler.createObserver(Void.self)
        viewModel.output.successAddCard.drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()
        
        viewModel.input.saveCreditCard(number: "5136 0025 3796 3755", name: "Teste", validThru: "03/20", cvv: "123")
        XCTAssertEqual(observer.events.count, 1)
    }
}
