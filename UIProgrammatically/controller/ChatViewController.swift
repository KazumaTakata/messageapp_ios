//
//  ChatViewController.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/23.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import Starscream

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentchatdata.count
    }
    var friendId = ""
    
    var currentchatdata:[tableChatdata] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath as IndexPath) as! chatcell
        cell.messageView.text = currentchatdata[indexPath.row].content
        
        cell.backgroundColor = ColorHolder.background
        if currentchatdata[indexPath.row].person == 0 {
           cell.rightconstraints?.isActive = true
           cell.leftconstraints?.isActive = false
           cell.messageView.backgroundColor = ColorHolder.chatbubble1
        } else {
            cell.rightconstraints?.isActive = false
            cell.leftconstraints?.isActive = true
            cell.messageView.backgroundColor = ColorHolder.chatbubble2
        }
        return cell
    }

    override func viewDidLoad() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        super.viewDidLoad()
        view.backgroundColor = ColorHolder.background
        
        view.addSubview(chatInputContainer)
        view.addSubview(chattableview)
        chatInputContainer.addSubview(chatinputfield)
        chatInputContainer.addSubview(chatsendbutton)
        
        chattableview.dataSource = self
        chattableview.delegate = self
        chattableview.backgroundColor = ColorHolder.background
        
        setListener()
        setlayout()
        loadtalkdata()
    }
    
    func setListener(){
        
        let messagewebsocket = MessageWebSocket.shared
        
        _ = messagewebsocket.messageSubject.subscribe(onNext: { message in
            print(message)
            let data = message.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,String>
            {
                print(jsonArray)
                self.insertToTable(content: jsonArray["content"]!, person: 1)
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        })
    }
    
    
    func loadtalkdata(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let chatFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        chatFetch.predicate = NSPredicate(format: "friendId = %@ && myId = %@", self.friendId, globalState.myId)
        let chats = try! managedContext.fetch(chatFetch)
        
        for chat in chats as! [NSManagedObject] {
            currentchatdata.append( tableChatdata(content: chat.value(forKey: "content") as! String, person: chat.value(forKey: "person") as! Int ) )
        }
        
        chattableview.reloadData()
    }
    
    let chatInputContainer: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    let chatinputfield: UITextField = {
        let uitextfield = UITextField()
        uitextfield.translatesAutoresizingMaskIntoConstraints = false
        

        return uitextfield
    }()
    func styletextfield(textfield: UITextField, placeholder: String){
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 10
        textfield.clipsToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textfield.frame.size.height))
        textfield.leftView = paddingView
        textfield.rightView = paddingView
        textfield.leftViewMode = .always
        textfield.rightViewMode = .always
        textfield.textColor = ColorHolder.textcolor
        textfield.placeholder = placeholder
    }

    
    let chattableview: UITableView = {
        let uitableview = UITableView()
        uitableview.translatesAutoresizingMaskIntoConstraints = false
        uitableview.register(chatcell.self, forCellReuseIdentifier: "chatcell")
        uitableview.separatorStyle = .none
        uitableview.allowsSelection = false
        return uitableview
    }()
    
    let chatsendbutton: UIButton = {
        let uibutton = UIButton()
        uibutton.translatesAutoresizingMaskIntoConstraints = false
        uibutton.setImage(#imageLiteral(resourceName: "addicon").withRenderingMode(UIImageRenderingMode.alwaysTemplate) , for: .normal)
        uibutton.tintColor = UIColor.white
        uibutton.addTarget(self, action:#selector(handlePush), for: .touchUpInside)
        return uibutton
    }()
    
    @objc func handlePush() {
        
        let chatcontent = chatinputfield.text!
        if (chatcontent != ""){
            // to server
            MessageWebSocket.shared.sendmessage(message: chatcontent, friendId: friendId)
            
            let chatdata = Chatdata(friendId: self.friendId , content: chatcontent, date: Date() , persion: 0, myId: globalState.myId)
            // to database
            DatabaseService.inserttodatabase(data: chatdata)
            
            // to tableview
            insertToTable(content: chatcontent, person: 0)
        }
    }
    
    private func insertToTable(content: String, person: Int){
        
        currentchatdata.append( tableChatdata(content: content, person: person) )
        let indexPath:IndexPath = IndexPath(row:(currentchatdata.count - 1), section:0)
        chattableview.beginUpdates()
        chattableview.insertRows(at: [IndexPath(row: currentchatdata.count-1, section: 0)], with: .automatic)
        chattableview.endUpdates()
        chattableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func setlayout(){
        
        chatInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        chatInputContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatInputContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatInputContainer.heightAnchor.constraint(equalToConstant:50).isActive = true
   
        
        chatinputfield.bottomAnchor.constraint(equalTo: chatInputContainer.bottomAnchor, constant: -10).isActive = true
        chatinputfield.rightAnchor.constraint(equalTo: chatInputContainer.rightAnchor, constant: -50).isActive = true
        chatinputfield.leftAnchor.constraint(equalTo: chatInputContainer.leftAnchor, constant: 10).isActive = true
        chatinputfield.topAnchor.constraint(equalTo: chatInputContainer.topAnchor).isActive = true
//        styletextfield(textfield: chatinputfield, placeholder: "chat")
        chatinputfield.decorateSelf(placeholder: "Hello!!")
        
        chatsendbutton.rightAnchor.constraint(equalTo: chatInputContainer.rightAnchor, constant: -10).isActive = true
        chatsendbutton.bottomAnchor.constraint(equalTo: chatInputContainer.bottomAnchor, constant:-15 ).isActive = true
        chatsendbutton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        chatsendbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        chattableview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        chattableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chattableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chattableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
     }
}

struct tableChatdata {
    var content: String
    var person : Int
}

struct Chatdata {
    var friendId: String
    var content: String
    var date: Date
    var persion: Int16
    var myId: String
}

