//
//  friendmodel.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/28.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import SwiftyJSON

struct userstruct: Codable {
    var namest: String
    var picurl: String
    var userId: String
    var backgroundurl: String
}


class friendModel {
    
    var friendData = [userstruct]()
    var delegate :friendModelDelegate?
    
    init(){}
    
    func addToUserdata(json: JSON){
        if (json.count > 0) {
            
            for index in 0...json.count - 1 {
                let name = json[index]["name"].string
                let url = json[index]["photourl"].string
                let Id = json[index]["id"].string
                let backurl = json[index]["backgroundurl"].string
                
                globalState.idtonameandphotourl[Id!] = ["name": name, "url": url, "backgroundurl": backurl] as? [String : String]
                
                let us = userstruct(namest: name!, picurl: url!, userId: Id!, backgroundurl: backurl! )
                friendData.append(us)
            }
        
        }
        
    
    }
    
    func getfriendsdata(){
        if friendData.count != 0 {
            friendData = [userstruct]()
        }
        let urlstring = "http://localhost:8181/api/friendslist"
        guard let Url = URL(string: urlstring) else { return }
        var request = URLRequest(url: Url)
        request.setValue(globalState.token, forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { (data, response
            , error) in
            do {
                let json = try JSON(data: data!)
                self.addToUserdata(json: json)
                self.delegate?.newfriends?()
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    
    
}


@objc protocol friendModelDelegate :class {
    @objc optional func newfriends()
}

