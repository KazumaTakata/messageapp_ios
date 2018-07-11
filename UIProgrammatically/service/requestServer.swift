//
//  requestServer.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/09.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import SwiftyJSON

class requestServer {
    
    static public func getRequest(url : String, completion: @escaping (JSON)->()) {
        
//        let urlstring = "http://localhost:8181/api/storedtalks"
        let urlstring = "http://localhost:8181/api/\(url)"
        guard let Url = URL(string: urlstring) else { return }
        var request = URLRequest(url: Url)
        request.setValue(globalState.token, forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                let json = try JSON(data: data!)
                
                completion(json)
                
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
        
    }
    
    static func getstoredtalks(){
     
        getRequest(url: "storedtalks", completion: { json in
            
            print(json)
            if json.count > 0{
                
                for index in 0...(json.count) - 1 {
                    let insertobj: Chatdata = Chatdata(friendId: json[index]["id"].string!, content: json[index]["content"].string!, date: Date(), persion: 1, myId: globalState.myId)
                    DispatchQueue.main.async {
                        DatabaseService.inserttodatabase(data: insertobj)
                    }
                }
            }
        })
        
    }
}
