//
//  AddCardViewController.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit
import InputMask

class AddCardViewController: ViewController {
    
    @IBOutlet var numberDelegate: MaskedTextFieldDelegate!
    @IBOutlet var validThruDelegate: MaskedTextFieldDelegate!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var numberTextField: SecondaryTextField!
    @IBOutlet weak var nameTextField: SecondaryTextField!
    @IBOutlet weak var validThruTextField: SecondaryTextField!
    @IBOutlet weak var cvvTextField: SecondaryTextField!
    @IBOutlet weak var confirmButton: PrimaryButton!
    @IBOutlet weak var flagImageView: UIImageView!
    private let viewModel: AddCardViewModelType = AddCardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardDismissable()
        observeKeyboardNotifications(with: mainScrollView)
        numberDelegate.listener = self
        validThruDelegate.listener = self
        
        titleLabel.text = "Adicionar cartão"
        
        numberTextField.leftPlaceHolderText = "Número do cartão"
        numberTextField.keyboardType = .numberPad
        numberTextField.placeholder = "0000 0000 0000 0000"
        
        nameTextField.leftPlaceHolderText = "Nome do cartão"
        nameTextField.placeholder = "FULANO DE TAL"
        nameTextField.keyboardType = .default
        
        validThruTextField.keyboardType = .numberPad
        validThruTextField.leftPlaceHolderText = "Validade"
        validThruTextField.placeholder = "MM/AA"
        
        cvvTextField.leftPlaceHolderText = "CVV"
        cvvTextField.placeholder = "000"
        
        confirmButton.setTitle("Confirmar", for: .normal)
        confirmButton.isEnabled = false
        
        flagImageView.contentMode = .scaleAspectFit
        
        initTextField()
    }
    
    fileprivate func initTextField() {
        
        nameTextField.rx
            .text
            .subscribe(onNext: { text in
                self.nameTextField.text = text?.safelyLimitedTo(length: 20)
                self.checkForm()
            })
            .disposed(by: disposeBag)
        
        validThruTextField.rx
            .text
            .subscribe(onNext: { _ in
                self.checkForm()
            })
            .disposed(by: disposeBag)
        
        cvvTextField.rx
            .text
            .subscribe(onNext: { text in
                self.cvvTextField.text = text?.safelyLimitedTo(length: 3)
                self.checkForm()
            })
            .disposed(by: disposeBag)
    }
    
    func checkForm() {
        if let number = numberTextField.text, let name = nameTextField.text,
            let validThru = validThruTextField.text, let cvv = cvvTextField.text {
            confirmButton.isEnabled = !number.isEmptyString && !name.isEmptyString
                && !validThru.isEmptyString && !cvv.isEmptyString
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.output.isLoading
            .drive(isLoading)
            .disposed(by: disposeBag)
        
        viewModel.output.error
            .drive(onNext: { error in
                self.showAlert(title: error.localizedDescription, message: "",
                               buttonText: "Ok",
                               alertAction: {})
            }).disposed(by: disposeBag)
        
        viewModel.output.onDataError
            .drive(onNext: { error in
                self.showAlert(title: error, message: "",
                               buttonText: "Ok",
                               alertAction: {})
            }).disposed(by: disposeBag)
        
        viewModel.output.successAddCard
            .drive(onNext: { response in
                self.onBackTapped()
            }).disposed(by: disposeBag)
    }
    
    @IBAction func onConfirmButtonTapped(_ sender: Any) {
        viewModel.input.saveCreditCard(number: numberTextField.text, name: nameTextField.text,
                                       validThru: validThruTextField.text, cvv: cvvTextField.text)
    }
}

extension AddCardViewController: MaskedTextFieldDelegateListener {
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        self.flagImageView.image = self.numberTextField.text?.digitsOnly().isValidCreditCard().type.flag
        self.flagImageView.layoutIfNeeded()
        self.checkForm()
    }

}
