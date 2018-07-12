//
//  messagewebsocket.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/09.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import Starscream
import RxSwift

class MessageWebSocket:  WebSocketDelegate {
    
    let socket: WebSocket?
    let messageSubject = PublishSubject<String>()
    
    static let shared = MessageWebSocket()
    
    
    private init(){
        print("init sokcet")
        socket = WebSocket(url: URL(string: "ws://localhost:8084")!)
        socket?.delegate = self
        socket?.connect()
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected!!!")
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: ["ping": "hey", "myId": globalState.token ], options: .prettyPrinted)
            self.socket?.write(data: jsonData)
        } catch {

        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        messageSubject.onNext(text)
        
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,String>
            {
                print(jsonArray)
                let insertobj:Chatdata = Chatdata(friendId: jsonArray["id"]!, content:  jsonArray["content"]!, date: Date(), persion: 1, myId: globalState.myId)
                DatabaseService.inserttodatabase(data: insertobj)
                
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    func sendmessage(message: String, friendId: String) {
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: ["content": message, "friendId": friendId, "myId": globalState.token ], options: .prettyPrinted)
            MessageWebSocket.shared.socket?.write(data: jsonData)
        } catch {
            
        }
    }
    
    
}


