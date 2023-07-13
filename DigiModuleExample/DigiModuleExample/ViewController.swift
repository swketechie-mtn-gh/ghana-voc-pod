//
//  ViewController.swift
//  DigiModuleExample
//
//  Created by Ilya Kostyukevich on 26.09.2022.
//

import UIKit
import DigiModule

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        DigiModule.shared.show(surveyId: 4536,
                               language: "en",
                               presentationController: self)
    }
}

