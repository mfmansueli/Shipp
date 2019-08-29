//
//  UIViewController+Extension.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 28/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit

extension UIViewController {
    func findTopMostViewController() -> UIViewController {
        return parent?.findTopMostViewController() ?? self
    }
}
