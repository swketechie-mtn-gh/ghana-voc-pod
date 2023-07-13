//
//  Extensions.swift
//  DigiModule
//
//  Created by Ilya Kostyukevich on 22.08.2022.
//

import UIKit

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}

extension UIView {
    func centerX(to anchor: NSLayoutXAxisAnchor, offset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
    }
    
    func centerY(to anchor: NSLayoutYAxisAnchor, offset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
    }
    
    func pinTop(to anchor: NSLayoutYAxisAnchor, offset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
    }
    
    func pinBottom(to anchor: NSLayoutYAxisAnchor, offset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
    }
    
    func pinLeft(to anchor: NSLayoutXAxisAnchor, offset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
    }
    
    func pinRight(to anchor: NSLayoutXAxisAnchor, offset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
    }
        
    func pinToCenter(ofView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
