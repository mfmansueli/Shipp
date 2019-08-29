//
//  DeliveryView.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 25/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class DeliveryView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DeliveryView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        titleLabel.text = "Delivery"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        mainView.backgroundColor = UIColor.App.lightSlateBlue
        
        infoButton.setImage(#imageLiteral(resourceName: "iconInfo"), for: .normal)
        infoButton.tintColor = .white
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Concierge Produtos", message: "- Esse serviço possui uma comissão de 10% sobre o valor dos produtos, sendo que esse valor somado a taxa de entrega jamais irá ultrapassar R$20,00.\n\n- As lojas parceiras da Shipp não possuem essa comissão.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, ENTENDI", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
