//
//  BaseViewController.swift
//  SingleForms
//
//  Created by Kostyukevich Ilya on 07.07.2022.
//

import UIKit

class BaseViewController: UIViewController {
    enum LoadType {
        case programmatically
        case xib
        case xibName(String)
    }
    
    init(loadType: LoadType = .xib) {
        var nibName: String
        
        switch loadType {
        case .programmatically:
            super.init(nibName: nil, bundle: nil)
            return
        case .xib:
            nibName = type(of: self).className
        case let .xibName(name):
            nibName = name
        }
        
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
