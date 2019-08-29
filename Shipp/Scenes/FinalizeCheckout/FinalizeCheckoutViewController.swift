//
//  FinalizeCheckoutViewController.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class FinalizeCheckoutViewController: ViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var storeNameLabel: TitleLabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var protuctDescriptionLabel: UILabel!
    
    @IBOutlet weak var estimatedValueTitleLabel: UILabel!
    @IBOutlet weak var estimatedValueLabel: UILabel!
    
    @IBOutlet weak var feeValueTitleLabel: UILabel!
    @IBOutlet weak var feeValueLabel: UILabel!
    
    @IBOutlet weak var totalEstimatedValueTitleLabel: UILabel!
    @IBOutlet weak var totalEstimatedValueLabel: UILabel!
    
    @IBOutlet weak var userLocationTitleLabel: UILabel!
    @IBOutlet weak var userCurrentLocationLabel: UILabel!
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var paymentTextField: SecondaryTextField!
    
    @IBOutlet weak var finalizeButton: PrimaryButton!
    
    private let viewModel: FinalizeCheckoutViewModelType = FinalizeCheckoutViewModel()
    
    var creditCard: CreditCard!
    var checkout: Checkout!
    var flagImageView: UIImageView!
    
    init(checkout: Checkout) {
        self.checkout = checkout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.loadCreditCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardDismissable()
        observeKeyboardNotifications(with: mainScrollView)

        storeNameLabel.text = checkout.storeName
        locationLabel.text = checkout.location
        locationLabel.textColor = UIColor.App.silver
        
        protuctDescriptionLabel.text = checkout.productInfo
        protuctDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        protuctDescriptionLabel.numberOfLines = 0
        
        estimatedValueTitleLabel.text = "Valor estimado"
        
        feeValueTitleLabel.text = "Taxa de entrega"
        
        totalEstimatedValueTitleLabel.text = "Valor estimado"
        
        estimatedValueLabel.textAlignment = .right
        estimatedValueLabel.text = checkout.value.asMoney()
        
        feeValueLabel.textAlignment = .right
        feeValueLabel.text = checkout.feeValue.asMoney()
        
        totalEstimatedValueLabel.textAlignment = .right
        totalEstimatedValueLabel.text = checkout.totalValue.asMoney()
        
        userLocationTitleLabel.text = "Entregando em:"
        userLocationTitleLabel.textColor = UIColor.App.silver
        userLocationTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        userCurrentLocationLabel.text = "Sua localização atual"
        
        paymentTextField.leftPlaceHolderText = "Pagamento"
        paymentTextField.customBorderColor = UIColor.App.lightSlateBlue
        
        paymentTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 50)
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 40, height: 16))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        let arrowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        arrowImageView.image = #imageLiteral(resourceName: "iconArrow")
        arrowImageView.tintColor = UIColor.App.lightSlateBlue
        arrowImageView.contentMode = .scaleAspectFit
        
        flagImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        flagImageView.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(flagImageView)
        stackView.addArrangedSubview(arrowImageView)
        paymentTextField.rightViewMode = .always
        paymentTextField.rightView = stackView
        
        paymentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPaymentViewTapped)))
        finalizeButton.setTitle("Finalizar pedido", for: .normal)
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
        
        viewModel.output.successDoFinalizeCheckout
            .drive(onNext: { response in
                self.present(ConfirmedOrderViewController(), animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                })
            }).disposed(by: disposeBag)
        
        viewModel.output.successLoadCreditCard
            .drive(onNext: { creditCard in
                guard let creditCard = creditCard else { return }
                self.creditCard = creditCard
                self.finalizeButton.isEnabled = true
                self.flagImageView.image = CreditCardType(rawValue: creditCard.type)?.flag
                self.paymentTextField.text = "**** **** **** \(creditCard.number.suffix(4))"
            }).disposed(by: disposeBag)
    }
    
    @objc func onPaymentViewTapped() {
        push(to: AddCardViewController())
    }
    
    @IBAction func onFinalizeButtonTapped(_ sender: Any) {
        viewModel.input.doFinalizeCheckout(checkout: checkout, creditCard: creditCard)
    }
}
