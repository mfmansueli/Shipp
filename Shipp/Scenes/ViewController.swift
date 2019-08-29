//
//  ViewController.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 22/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit
import GooglePlaces
import RxSwift
import MBProgressHUD
import RxCocoa

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var scrollView: UIScrollView?
    let disposeBag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNavigationBar()
        bindViewModel()
    }
    
    func initializeNavigationBar() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "iconBack")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "iconBack")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(onBackTapped))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconClose"), style: .plain, target: self, action: #selector(onCloseButtonTapped))
    }
    
    func bindViewModel() {
        isLoading.asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            }).disposed(by: disposeBag)
    }
    
    func showLoading() {
        view.endEditing(true)
        let hud = MBProgressHUD.showAdded(to: self.findTopMostViewController().view, animated: true)
        hud.backgroundView.color = UIColor.black.withAlphaComponent(CGFloat(0.35))
        hud.backgroundView.style = .solidColor
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self.findTopMostViewController().view, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc func onBackTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onCloseButtonTapped() {
        let alert = UIAlertController(title: "Deseja cancelar o pedido?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { action in
            switch action.style {
            case .default:
                self.navigationController?.popToRootViewController(animated: true)
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setKeyboardDismissable() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        let viewGesture = gesture.view
        let loc = gesture.location(in: viewGesture)
        if let subview = viewGesture?.hitTest(loc, with: nil), subview.isKind(of: UIButton.self) {
            return
        }
        view.endEditing(true)
    }
    
    func observeKeyboardNotifications(with scrollView: UIScrollView?) {
        self.scrollView = scrollView
        self.scrollView?.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else { return }
        
        keyboardWillAppear(with: keyboardSize.size, duration: animationDuration)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size,
            let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else { return }
        
        
        for view in self.view.subviews {
            if let textField = view as? UITextField, textField.isFirstResponder {
                textField.resignFirstResponder()
            }
        }
        
        keyboardWillDisappear(with: keyboardSize, duration: animationDuration)
    }
    
    func keyboardWillAppear(with size: CGSize, duration: TimeInterval) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
        
        var rect = view.frame
        rect.size.height -= size.height
        guard let activeTextFieldFrame = findActiveTextField(view.subviews) else { return }
        
        if !rect.contains(activeTextFieldFrame.origin) {
            scrollView?.scrollRectToVisible(activeTextFieldFrame, animated: true)
        }
    }
    
    func findActiveTextField(_ subviews: [UIView]) -> CGRect? {
        for view in subviews {
            if let textField = view as? UITextField, textField.isFirstResponder {
                return textField.frame
            }
            
            return findActiveTextField(view.subviews)
        }
        return nil
    }
    
    func keyboardWillDisappear(with size: CGSize, duration: TimeInterval) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    func showAlert(title: String, message: String, buttonText: String,
                   alertAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
                alertAction()
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func push(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

