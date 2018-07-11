//
//  messagewebsocket.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/09.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import Starscream

protocol listenerProtocol {
    func messageCome(message: String)
}

class MessageWebSocket:  WebSocketDelegate {
    
    let socket: WebSocket?
    let delegates = MulticastDelegate<listenerProtocol>()
    
    static let shared = MessageWebSocket()
    
//    var listernerContainer: [UIViewController] = []
    
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
        delegates.invoke {
            $0.messageCome(message: text)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
}

class MulticastDelegate <T> {
    private var delegates = [T]()
    
    func addDelegate(delegate: T) {
        delegates.append(delegate)
    }
    
    func invoke(invocation: (T) -> ()) {
        // Enumerating in reverse order prevents a race condition from happening when removing elements.
        for delegate in delegates {
            invocation(delegate)
        }
    }
}
