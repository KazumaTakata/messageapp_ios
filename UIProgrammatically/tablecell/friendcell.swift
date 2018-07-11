//
//  tablecell.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/22.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import UIKit

class friendcell: UITableViewCell {
    
    var message: String?
    var mainImage: UIImage?
    
    var messageView : UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 20)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.backgroundColor = UIColor.clear
        textview.textColor = UIColor.white
        textview.isEditable = false
        textview.isScrollEnabled = false
        return textview
    }()
    
    var mainImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageView)
        self.addSubview(mainImageview)

        messageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        messageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 80).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageView.alignTextVerticallyInContainer()
        
        mainImageview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainImageview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        mainImageview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mainImageview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mainImageview.layer.cornerRadius = 25
        mainImageview.clipsToBounds = true
        mainImageview.contentMode = UIViewContentMode.scaleAspectFill
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.backgroundColor = UIColor.clear

    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

