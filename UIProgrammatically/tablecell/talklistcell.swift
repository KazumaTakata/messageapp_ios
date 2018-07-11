//
//  talklistcell.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/29.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation

import UIKit

class talklistcell: UITableViewCell {
    
    var friendName : UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 20)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.isEditable = false
        textview.textColor = ColorHolder.textcolor
        textview.backgroundColor = UIColor.clear
        textview.isScrollEnabled = false
        return textview
    }()
    
    var chatcontent : UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 14)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.isEditable = false
        textview.backgroundColor = UIColor.clear
        textview.textColor = ColorHolder.textcolor
        textview.isScrollEnabled = false
        return textview
    }()
    
    var profilephoto: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = UIViewContentMode.scaleAspectFill
        return imageview
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(friendName)
        self.addSubview(profilephoto)
        self.addSubview(chatcontent)
        
        friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        friendName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        friendName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 80).isActive = true
        friendName.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        friendName.alignTextVerticallyInContainer()
        
        chatcontent.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
//        chatcontent.heightAnchor.constraint(equalToConstant: 40).isActive = true
        chatcontent.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 80).isActive = true
        chatcontent.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        chatcontent.alignTextVerticallyInContainer()
        
        profilephoto.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profilephoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profilephoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profilephoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilephoto.layer.cornerRadius = 25
        profilephoto.clipsToBounds = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

