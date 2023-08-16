//
//  AppDelegate.swift
//  DigiModuleExample
//
//  Created by Ilya Kostyukevich on 26.09.2022.
//

import UIKit
import DigiModule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DigiModule.shared.initialization(urlString: "https://stage1-astra.surv.biz/digi_runner.js")
        
        return true
    }
}

