//
//  databaseservice.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/09.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseService{
        
    static func inserttodatabase(data:Chatdata){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let chatEntity = NSEntityDescription.entity(forEntityName: "Chat", in: managedContext)!
        let chat = NSManagedObject(entity: chatEntity, insertInto: managedContext)
        
        chat.setValue(data.friendId , forKey: "friendId")
        chat.setValue(data.content , forKey: "content")
        chat.setValue(data.date , forKey: "date")
        chat.setValue(data.persion, forKey: "person")
        chat.setValue(data.myId, forKey: "myId")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
