//
//  AppDelegate.swift
//  Shipp
//
//  Created by Mateus Ferneda Mansueli on 22/08/19.
//  Copyright © 2019 shipp. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyCUTSFo4v3UQ-w21ryCfIvbRo6GHvPqCTc")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if let window = self.window {
            
            let controller = UINavigationController(rootViewController: SearchPlaceViewController())

            controller.navigationBar.shadowImage = UIImage()
            controller.navigationBar.barTintColor = UIColor.App.lightSlateBlue
            controller.navigationBar.isTranslucent = false
            window.rootViewController = controller
        }
        return true
    }

}

