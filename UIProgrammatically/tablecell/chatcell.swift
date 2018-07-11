//
//  tablecell.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/22.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import UIKit

class chatcell: UITableViewCell {
    
    var message: String?
    var rightconstraints  :NSLayoutConstraint?
    var leftconstraints  :NSLayoutConstraint?
    
    var messageView : UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 20)
        textview.translatesAutoresizingMaskIntoConstraints = false
        
        textview.isEditable = false
        textview.isScrollEnabled = false
        textview.backgroundColor = UIColor(hue: 0.4222, saturation: 0.61, brightness: 0.8, alpha: 1.0)
        textview.layer.cornerRadius =  15
        textview.clipsToBounds = true
        textview.textColor = .white
        
        return textview
    }()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageView)
        
        
        rightconstraints = messageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        leftconstraints = messageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        messageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -20).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UITextView {
    
    func alignTextVerticallyInContainer() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        self.contentInset.top = topCorrect
    }
}
