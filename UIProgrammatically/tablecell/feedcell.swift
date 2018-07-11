//
//  talklistcell.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/29.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation

import UIKit

class feedlistcell: UITableViewCell {
    
    var profilephoto: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var profilename: UILabel = {
        let uilabel = UILabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textColor = ColorHolder.textcolor
        uilabel.backgroundColor = UIColor.clear
        return uilabel
    }()
    
    var mainphoto: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var maintext:  UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 14)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = ColorHolder.textcolor
        textview.backgroundColor = UIColor.clear
        textview.isEditable = false
        textview.isScrollEnabled = false
    
        
        return textview
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profilephoto)
        self.addSubview(mainphoto)
        self.addSubview(maintext)
        self.addSubview(profilename)
        
        profilephoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        profilephoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profilephoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profilephoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilephoto.layer.cornerRadius = 25
        profilephoto.clipsToBounds = true
        profilephoto.contentMode = UIViewContentMode.scaleAspectFill
        
        profilename.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        profilename.leftAnchor.constraint(equalTo: profilephoto.rightAnchor , constant: 20).isActive = true
        profilename.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        profilename.bottomAnchor.constraint(equalTo: mainphoto.topAnchor, constant:-10).isActive = true
        
       
    
   
        
        mainphoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        mainphoto.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        mainphoto.topAnchor.constraint(equalTo: profilephoto.bottomAnchor, constant: 20).isActive = true
        mainphoto.heightAnchor.constraint(equalToConstant: 300).isActive = true
        mainphoto.bottomAnchor.constraint(equalTo: maintext.topAnchor, constant: -20).isActive = true
        mainphoto.contentMode = UIViewContentMode.scaleAspectFill
        mainphoto.clipsToBounds = true
        
        
        
        maintext.topAnchor.constraint(equalTo: mainphoto.bottomAnchor, constant: 20).isActive = true
        maintext.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        maintext.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        maintext.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class feedlistfirstcell: UITableViewCell {
    
    var profilephoto: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var profilename: UILabel = {
        let uilabel = UILabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textColor = ColorHolder.textcolor
        uilabel.backgroundColor = UIColor.clear
        return uilabel
    }()
    
    var mainphoto: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var maintext:  UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 14)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = ColorHolder.textcolor
        textview.backgroundColor = UIColor.clear
        textview.isEditable = false
        textview.isScrollEnabled = false
        
        
        return textview
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profilephoto)
        self.addSubview(mainphoto)
        self.addSubview(maintext)
        self.addSubview(profilename)
        
        profilephoto.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        profilephoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profilephoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profilephoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilephoto.layer.cornerRadius = 25
        profilephoto.clipsToBounds = true
        profilephoto.layer.zPosition = 4
        profilephoto.contentMode = UIViewContentMode.scaleAspectFill
        
        
        profilename.leftAnchor.constraint(equalTo: profilephoto.rightAnchor , constant: 20).isActive = true
        profilename.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35).isActive = true
        profilename.layer.zPosition = 4
        
        
        mainphoto.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainphoto.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainphoto.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainphoto.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainphoto.layer.zPosition = 3
        mainphoto.contentMode = UIViewContentMode.scaleAspectFill
        mainphoto.clipsToBounds = true
        self.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



