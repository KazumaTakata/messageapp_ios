//
//  ViewController.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/21.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import UIKit
import PureLayout
import Alamofire
import SwiftyJSON
import Starscream
import CoreData

class FriendListviewController: UIViewController,UITableViewDelegate, UITableViewDataSource, friendModelDelegate, listenerProtocol {
    
    func messageCome(message: String) {
        print("got some text: \(message)")
        let data = message.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,String>
            {
                print(jsonArray)
                let insertobj:Chatdata = Chatdata(friendId: jsonArray["id"]!, content:  jsonArray["content"]!, date: Date(), persion: 1, myId: globalState.myId)
                DatabaseService.inserttodatabase(data: insertobj)

//                chatviewcontrollerobject?.inserttotable(sentfriendId: jsonArray["id"]!, chatcontent: jsonArray["content"]!)
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    var tappedfriend = ""
    var mytableview: UITableView?
    var friendsData = friendModel()
    var chatviewcontrollerobject: ChatViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        friendsData.getfriendsdata()
      
    }
    
    func newfriends() {
        DispatchQueue.main.async {
            self.mytableview?.reloadData()
        }
    }
    
    var socket: WebSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messagewebsocket = MessageWebSocket.shared
        messagewebsocket.delegates.addDelegate(delegate: self)
    
        view.backgroundColor = ColorHolder.background
        navigationItem.title = "friends"
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        
        mytableview = setTable()
        mytableview?.tableFooterView = UIView()
        
        view.addSubview(mytableview!)
        
        
        friendsData.delegate = self
        
        requestServer.getstoredtalks()
        
        
        let rightbutton = UIButton()
        
        rightbutton.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        rightbutton.tintColor = UIColor.white
        rightbutton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightbutton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rightbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightbutton.addTarget(self , action: #selector(addTapped) , for: .touchUpInside )
        
        let leftbutton = UIButton()
        
        leftbutton.setImage(#imageLiteral(resourceName: "user_male").withRenderingMode(.alwaysTemplate), for: .normal)
        leftbutton.tintColor = UIColor.white
        leftbutton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        leftbutton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        leftbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        leftbutton.addTarget(self , action: #selector(changeprofile) , for: .touchUpInside )
        
        let rightnavbarItem = UIBarButtonItem(customView: rightbutton)
        let leftnavbarItem = UIBarButtonItem(customView: leftbutton)
        
        navigationItem.rightBarButtonItem = rightnavbarItem
        navigationItem.leftBarButtonItem = leftnavbarItem
        
        setupLayout()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.friendData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print( friendsData.friendData[indexPath.row] )
        tappedfriend = friendsData.friendData[indexPath.row].userId
        
        modalrender(index: indexPath.row)

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! friendcell
        cell.messageView.text = friendsData.friendData[indexPath.row].namest
        let imgurl = friendsData.friendData[indexPath.row].picurl
        let url = URL(string: imgurl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.mainImageview.image  = UIImage(data: data!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    
    private func modalrender(index:Int){
        self.view.addSubview(modalbackground)
        
        modalbackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        modalbackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        modalbackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        modalbackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        modalbackground.layer.zPosition = 5
        modalbackground.addSubview(modalview)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handletap))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        modalbackground.addGestureRecognizer(tap)
        modalbackground.isUserInteractionEnabled = true
        
        
        
        modalview.centerXAnchor.constraint(equalTo: modalbackground.centerXAnchor).isActive = true
        modalview.centerYAnchor.constraint(equalTo: modalbackground.centerYAnchor).isActive = true
        
       
        let backurl = URL(string: friendsData.friendData[index].backgroundurl)
        let backgroundimg = try? Data(contentsOf: backurl!)
        homeimg.image = UIImage(data: backgroundimg!)
        modalview.addSubview(homeimg)
        homeimg.topAnchor.constraint(equalTo: modalview.topAnchor).isActive = true
        homeimg.rightAnchor.constraint(equalTo: modalview.rightAnchor).isActive = true
        homeimg.leftAnchor.constraint(equalTo: modalview.leftAnchor).isActive = true
        homeimg.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let tapimg = UITapGestureRecognizer(target: self, action: #selector(handletapimg))
        tapimg.numberOfTapsRequired = 1
        tapimg.numberOfTouchesRequired = 1
        homeimg.addGestureRecognizer(tapimg)
        
        
        let picurl = URL(string: friendsData.friendData[index].picurl)
        let picimg = try? Data(contentsOf: picurl!)
        modalphoto.image = UIImage(data: picimg!)
        
        modalview.addSubview(modalphoto)
        modalphoto.topAnchor.constraint(equalTo: modalview.topAnchor, constant: 75).isActive = true
        modalphoto.centerXAnchor.constraint(equalTo: modalview.centerXAnchor).isActive = true
        modalphoto.layer.zPosition = 2
        
        
        modalview.addSubview(blankrect)
        blankrect.topAnchor.constraint(equalTo: homeimg.bottomAnchor).isActive = true
        blankrect.rightAnchor.constraint(equalTo: modalview.rightAnchor).isActive = true
        blankrect.leftAnchor.constraint(equalTo: modalview.leftAnchor).isActive = true
        blankrect.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        modalview.addSubview(buttonstackview)
        buttonstackview.topAnchor.constraint(equalTo: blankrect.bottomAnchor).isActive = true
        buttonstackview.rightAnchor.constraint(equalTo: modalview.rightAnchor).isActive = true
        buttonstackview.leftAnchor.constraint(equalTo: modalview.leftAnchor).isActive = true
        buttonstackview.bottomAnchor.constraint(equalTo: modalview.bottomAnchor).isActive = true
        
        
        buttonstackview.addArrangedSubview(talkbutton)
        buttonstackview.addArrangedSubview(homebutton)
    }
    
    
    let modalview :UIView = {
       let uiview = UIView()
       uiview.translatesAutoresizingMaskIntoConstraints = false
       uiview.heightAnchor.constraint(equalToConstant: 200).isActive = true
       uiview.widthAnchor.constraint(equalToConstant: 200).isActive = true
       return uiview
    }()
    
    let modalphoto :UIImageView = {
       let uiimagephoto = UIImageView()
       uiimagephoto.translatesAutoresizingMaskIntoConstraints = false
       uiimagephoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
       uiimagephoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
       uiimagephoto.layer.cornerRadius = 25
       uiimagephoto.clipsToBounds = true
       uiimagephoto.image = #imageLiteral(resourceName: "mahir-uysal-715722-unsplash")
       uiimagephoto.contentMode = UIViewContentMode.scaleAspectFill
       return uiimagephoto
    }()
    
    let modalbackground :UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return uiview
    }()
    
    
    let homeimg :UIImageView = {
        let uiimageview = UIImageView()
        uiimageview.translatesAutoresizingMaskIntoConstraints = false
        uiimageview.isUserInteractionEnabled = true
        return uiimageview
    }()
    
    let buttonstackview :UIStackView = {
        let uistackview = UIStackView()
        uistackview.translatesAutoresizingMaskIntoConstraints = false
        uistackview.axis = .horizontal
        uistackview.distribution = .fillEqually
        uistackview.backgroundColor = .white
        return uistackview
    }()
    
    let blankrect :UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .white
        uiview.isUserInteractionEnabled = true
        
        return uiview
    }()
    
    let talkbutton :UIButton = {
        let uibutton = UIButton()
        uibutton.translatesAutoresizingMaskIntoConstraints = false
        uibutton.setTitle("talk", for: .normal)
        uibutton.setTitleColor(ColorHolder.textcolor2 , for: .normal)
        uibutton.backgroundColor = .white
        uibutton.addTarget(self, action: #selector(gotoTalk), for: .touchUpInside)
        uibutton.layer.borderColor = ColorHolder.textcolor2.cgColor
       
        return uibutton
    }()
    
    
    let homebutton :UIButton = {
        let uibutton = UIButton()
        uibutton.translatesAutoresizingMaskIntoConstraints = false
        uibutton.setTitle("home", for: .normal)
        uibutton.setTitleColor(ColorHolder.textcolor2, for: .normal)
        uibutton.backgroundColor = .white
        uibutton.addTarget(self, action: #selector(gotoHome), for: .touchUpInside)
//        uibutton.layer.borderWidth = 1
//        uibutton.layer.borderColor = ColorHolder.textcolor2.cgColor
    
        return uibutton
    }()
    
    private func setTable() -> UITableView {
        let myTableView = UITableView()
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.register(friendcell.self, forCellReuseIdentifier: "MyCell")
        myTableView.backgroundColor = ColorHolder.background
        myTableView.dataSource = self
        myTableView.delegate = self
        return myTableView
    }
    

    @objc func changeprofile(){
        navigationController?.pushViewController(changeProfileViewController(), animated: true)
    }
    
    @objc func addTapped(){
        let addfriend = addfriendViewController()
//        addfriend.frienddata = friendsData
        let friendIds = extractId(friendData: friendsData.friendData)
        addfriend.friendIds = friendIds
        
        navigationController?.pushViewController(addfriend, animated: true)
    }

    @objc func gotoTalk(){
        chatviewcontrollerobject = ChatViewController()
        chatviewcontrollerobject?.friendId = tappedfriend
        navigationController?.pushViewController(chatviewcontrollerobject!, animated: true)
    }
    @objc func gotoHome(){
        let homeviewcontrollerobject = HomeViewController()
//        homeviewcontrollerobject.friendId = tappedfriend
        homeviewcontrollerobject.friendId = tappedfriend
        navigationController?.pushViewController(homeviewcontrollerobject, animated: true)
    }
    
    @objc func handletapimg(){
        print("img tapped")
    }
    
    @objc func handletap(){
        modalbackground.removeFromSuperview()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("ee")
        } else {
            print("fed")
        }
        
    }
    private func setupLayout(){
        
        let navbarheight = (navigationController?.navigationBar.frame.height)!
        mytableview?.topAnchor.constraint(equalTo: view.topAnchor, constant: navbarheight + 20).isActive = true
        mytableview?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mytableview?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mytableview?.bottomAnchor.constraint(equalTo:view.bottomAnchor ).isActive = true
    }
    
}
