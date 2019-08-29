//
//  CheckoutViewController.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 26/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit
import GooglePlaces
import RxSwift

class CheckoutViewController: ViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var storeNameLabel: TitleLabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var productTitleLabel: TitleLabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productTextView: PrimaryTextView!
    @IBOutlet weak var productTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var valueTitleLabel: TitleLabel!
    @IBOutlet weak var valueDescriptionLabel: UILabel!
    @IBOutlet weak var valueTextView: PrimaryTextView!
    
    @IBOutlet weak var finalizeButton: PrimaryButton!
    
    var checkout: Checkout!
    private let viewModel: CheckoutViewModelType = CheckoutViewModel()
    
    init(checkout: Checkout) {
        self.checkout = checkout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onStoreViewTapped)))
        initStoreView()
        locationLabel.textColor = UIColor.App.silver
        
        productTitleLabel.text = "O que você deseja?"
        productDescriptionLabel.text = "Descreva direitinho o que você deseja dessa loja que um shipper vai até lá comprar pra você :)"
        productDescriptionLabel.numberOfLines = 0
        productDescriptionLabel.textColor = UIColor.App.silver
        productTextView.placeholder = "Produto da loja"
        productTextView.heightConstraint = productTextViewHeightConstraint
        
        valueTitleLabel.text = "Quanto?"
        valueDescriptionLabel.text = "Estime um valor para seu pedido, fique tranquilo, o valor cobrado será o da nota fiscal"
        valueDescriptionLabel.numberOfLines = 0
        valueDescriptionLabel.textColor = UIColor.App.silver
        valueTextView.placeholder = "R$ 0,00"
        valueTextView.returnKeyType = .done
        valueTextView.keyboardType = .numberPad
        valueTextView.isMoney = true
        
        finalizeButton.setTitle("Finalizar pedido", for: .normal)
        finalizeButton.isEnabled = false
        
        setKeyboardDismissable()
        observeKeyboardNotifications(with: mainScrollView)
        
        valueTextView.rx
            .text
            .subscribe(onNext: { _ in
                self.finalizeButton.isEnabled = self.productTextView.text != self.productTextView.placeholder
                    && self.valueTextView.text != self.valueTextView.placeholder
                    && !self.productTextView.text.isEmptyString
                    && !self.valueTextView.text.isEmptyString
            })
            .disposed(by: disposeBag)
        
        productTextView.rx
            .text
            .subscribe(onNext: { _ in
                self.finalizeButton.isEnabled = self.productTextView.text != self.productTextView.placeholder
                    && self.valueTextView.text != self.valueTextView.placeholder
                    && !self.productTextView.text.isEmptyString
                    && !self.valueTextView.text.isEmptyString
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func initStoreView() {
        storeNameLabel.text = checkout.storeName
        locationLabel.text = checkout.location
    }
    
    @objc func onStoreViewTapped() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue)
            | UInt(GMSPlaceField.placeID.rawValue)
            | UInt(GMSPlaceField.formattedAddress.rawValue)
            | UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func onFinalizeButtonTapped(_ sender: Any) {
        checkout.value = (Double(valueTextView.text.digitsOnly()) ?? 0) / 100
        checkout.productInfo = productTextView.text == productTextView.placeholder ? "" : productTextView.text
        
        viewModel.input.doCheckout(checkout: checkout)
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
        
        viewModel.output.successDoCheckout
            .drive(onNext: { response in
                self.checkout.totalValue = response.totalValue
                self.checkout.distance = response.distance
                self.checkout.feeValue = response.feeValue
                self.push(to: FinalizeCheckoutViewController(checkout: self.checkout))
            }).disposed(by: disposeBag)
    }
        
}

extension CheckoutViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self else { return }
                self.checkout.storeName = place.name
                self.checkout.location = place.formattedAddress
                self.checkout.storeLatitude = place.coordinate.latitude
                self.checkout.storeLongitude = place.coordinate.longitude
            self.initStoreView()
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
