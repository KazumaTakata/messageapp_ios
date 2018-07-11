//
//  login_validation.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/09.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import UIKit

struct login_input_return_struct {
    let success: Bool
    let message: String
}

func login_input_validation(name: String, password: String)-> login_input_return_struct {
    
    if (name != "" && password != ""){
        
        if ( 3 < (name.count)  && (name.count) < 10 ){
            if ( 3 < password.count  && password.count < 10 ) {
                return login_input_return_struct(success: true, message: "ok")
            } else {
                return login_input_return_struct(success: false, message: "length of password is not correct")
            }
        } else {
            return login_input_return_struct(success: false, message: "length of name is not correct")
        }
        
       
    
    } else {
        return login_input_return_struct(success: false, message: "name or password is empty")
    }
}

func userId_input_validation(userId: String)-> Bool {
    
    if (userId.count == 24) {
        let intvalue = UInt(userId, radix: 16)!
        return true
    } else {
        return false
    }
}


func showalert(title: String, message: String) -> UIAlertController{
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style{
        case .default:
            print("default")
            
        case .cancel:
            print("cancel")
            
        case .destructive:
            print("destructive")
            
        }}))
    
    return alert
    
}




func extractId( friendData :[userstruct]) -> [String] {
    
    return friendData.map {
        value in value.userId
    }
    
}



