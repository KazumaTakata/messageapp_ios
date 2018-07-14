//
//  friendmodel.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/28.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct userstruct{
    var name: String
    var pic: UIImage
    var userId: String
    var backgroundpic: UIImage
}


class friendModel {
    
    var friendData = [userstruct]()
    var delegate :friendModelDelegate?
    
    init(){}
    
    func addToUserdata(json: JSON){
        if (json.count > 0) {
            
            for index in 0...json.count - 1 {
                let name = json[index]["name"].string
                let photourl = json[index]["photourl"].string
                let Id = json[index]["id"].string
                let backurl = json[index]["backgroundurl"].string
                
                globalState.idtonameandphotourl[Id!] = ["name": name, "url": photourl, "backgroundurl": backurl] as? [String : String]
                
                let profilephoto = try? Data(contentsOf: URL(string: photourl!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                let backgroundphoto = try? Data(contentsOf: URL(string: backurl!)!)
                
                
                let us = userstruct(name: name!, pic: UIImage(data:profilephoto!)! , userId: Id!, backgroundpic: UIImage(data:backgroundphoto!)! )
                friendData.append(us)
            }
        }
    }
    
    func getfriendsdata(){
        if friendData.count != 0 {
            friendData = [userstruct]()
        }
        
        requestServer.getRequest(url: "friendslist", completion: { json in
            self.addToUserdata(json: json)
            self.delegate?.newfriends?()
            
        })
        
        
    }
    
    
}


@objc protocol friendModelDelegate :class {
    @objc optional func newfriends()
}

