//
//  SearchPlaceViewController.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 23/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchPlaceViewController: ViewController {
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var searchPlaceView: UIView!
    @IBOutlet weak var searchPlaceTextField: PrimaryTextField!
    @IBOutlet weak var finalizeButton: PrimaryButton!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var location: CLLocation?
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    fileprivate func initLayout() {
        finalizeButton.setTitle("Finalizar pedido", for: .normal)
        
        titleLabel.text = "Onde podemos encontrar\no que você deseja?"
        searchPlaceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSearchPlaceViewTapped)))
        
        searchPlaceTextField.placeholder = "Busca"
        finalizeButton.isEnabled = false
    }
    
    @objc func onSearchPlaceViewTapped() {
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
}

extension SearchPlaceViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == .denied || authorizationStatus == .restricted {
                let alertController = UIAlertController(title: "Permitir acesso a sua localização",
                                                        message: "O acesso ao gps foi negado, altere a permissão nas configurações do aplicativo.",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancelar", style: .default))
                alertController.addAction(UIAlertAction(title: "Configurações", style: .cancel) { _ in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                self.present(alertController, animated: true)
                return
            }
            
            if let location = self.location ?? self.locationManager.location {
                let checkout = Checkout(storeName: place.name,
                                        location: place.formattedAddress,
                                        storeLatitude: place.coordinate.latitude,
                                        storeLongitude: place.coordinate.longitude,
                                        userLatitude: location.coordinate.latitude,
                                        userLongitude: location.coordinate.longitude)
                self.push(to: CheckoutViewController(checkout: checkout))
            }
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

extension SearchPlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            location = manager.location
        }
    }
}
