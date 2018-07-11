//
//  friendmodel.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/28.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

struct talkcellstruct {
    var friendname: String
    var content: String
    var photourl: String
    var friendId: String
}


class talklistModel {
    
    var chatData = [talkcellstruct]()
    var delegate :chatmodelDelegate?
    
    init(){}
    
    var fetchedData = [String:AnyObject]()
    
    func getchatsdata(){
        chatData = [talkcellstruct]()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let chatFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        chatFetch.predicate = NSPredicate(format: "myId = %@", globalState.myId)
        let chats = try! managedContext.fetch(chatFetch)
        
        for chat in chats as! [NSManagedObject] {

            var tmpdict = [String: Any]()
            tmpdict["content"] = chat.value(forKey: "content")! as! String
            tmpdict["date"] = chat.value(forKey: "date")! as! Date
            tmpdict["friendId"] = chat.value(forKey: "friendId")! as! String
            
            if fetchedData[tmpdict["friendId"] as! String] == nil {
                fetchedData[tmpdict["friendId"] as! String ] = ["content": tmpdict["content"], "date": tmpdict["date"]] as AnyObject
            } else {
                if (fetchedData[tmpdict["friendId"] as! String]!["date"] as! Date  ) <  tmpdict["date"] as! Date {
                    fetchedData[tmpdict["friendId"] as! String ] = ["content": tmpdict["content"], "date": tmpdict["date"]] as AnyObject
                
                }
            }
        }
        var fetchedlist = [[String: Any]]()
        print(fetchedData)
        let keys = Array(fetchedData.keys)
        for key in keys {
            fetchedlist.append(["friendId": key , "date": fetchedData[key]!["date"] as! Date, "content": fetchedData[key]!["content"] as! String ])
        }
        
        print(fetchedlist)
        let sortedlist = fetchedlist.sorted(by: { ($0["date"]! as! Date) > ($1["date"]! as! Date)  })
        print(sortedlist)
      
        for chatdata in sortedlist {
            let friendId = chatdata["friendId"] as! String
            let content = chatdata["content"] as! String
            let name =  globalState.idtonameandphotourl[friendId]!["name"]
            let url =  globalState.idtonameandphotourl[friendId]!["url"]
            
            chatData.append( talkcellstruct(friendname: name!, content: content, photourl: url!, friendId: friendId) )
        }
        print(chatData)
        
        self.delegate?.newfriends!()
    }
}

@objc protocol chatmodelDelegate :class {
    @objc optional func newfriends()
}
