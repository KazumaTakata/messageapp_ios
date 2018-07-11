//
//  extension.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/10.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import UIKit


extension UILabel {
    func addCharactersSpacing(_ value: CGFloat = 1.15) {
        if let textString = text {
            let attrs: [NSAttributedStringKey : Any] = [.kern: value]
            attributedText = NSAttributedString(string: textString, attributes: attrs)
        }
    }
}

extension UITextField {
    
    func decorateSelf(placeholder: String){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = .always
        self.rightViewMode = .always
        self.textColor = UIColor.white
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor(hue: 0.2639, saturation: 0.04, brightness: 0.81, alpha: 1.0) ])
    }
    
}

extension UIImageView {
    
    func makeround(circlesize: Int) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.heightAnchor.constraint(equalToConstant: CGFloat(circlesize)).isActive = true
        self.widthAnchor.constraint(equalToConstant: CGFloat(circlesize)).isActive = true
        self.layer.cornerRadius = CGFloat(circlesize/2)
        self.clipsToBounds = true
        
    }
}
