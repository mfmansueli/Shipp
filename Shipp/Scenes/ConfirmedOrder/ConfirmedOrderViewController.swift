//
//  ConfirmedOrderViewController.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 27/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

class ConfirmedOrderViewController: ViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: PrimaryButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.setImage(#imageLiteral(resourceName: "iconClose"), for: .normal)
        closeButton.tintColor = .white
        
        view.backgroundColor = UIColor.App.lightSlateBlue
        
        imageView.image = #imageLiteral(resourceName: "iconChecked")
        imageView.contentMode = .scaleAspectFit

        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        messageLabel.text = "Pedido confirmado"
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        
        actionButton.setTitle("Acompanhar pedido", for: .normal)
        actionButton.customBackgroundColor = .white
        actionButton.customTitleColor = UIColor.App.lightSlateBlue
    }
    
    @IBAction func onActionButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
