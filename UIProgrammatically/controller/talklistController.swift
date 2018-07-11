//
//  talklistController.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/25.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

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


class talkListController: UIViewController,UITableViewDelegate, UITableViewDataSource, chatmodelDelegate {
    
    
    var talkListModel: talklistModel?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (talkListModel?.chatData.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let chatconstroller = ChatViewController()
        chatconstroller.friendId = (talkListModel?.chatData[indexPath.row].friendId)!
        
        navigationController?.pushViewController(chatconstroller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "talklistcell", for: indexPath as IndexPath) as! talklistcell
        
        let url = URL(string:(talkListModel?.chatData[indexPath.row].photourl)!)
        let photodata = try? Data(contentsOf: url!)
        cell.profilephoto.image = UIImage(data: photodata!)
        cell.backgroundColor = ColorHolder.background
        cell.friendName.text = talkListModel?.chatData[indexPath.row].friendname
        cell.chatcontent.text = talkListModel?.chatData[indexPath.row].content
        cell.friendName.sizeToFit()
        cell.chatcontent.sizeToFit()
//        cell.addBottomBorderWithColor(color: ColorHolder.textcolor, width: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func newfriends() {
        mytableview?.reloadData()
    }
    
    var mytableview: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorHolder.background
        navigationItem.title = "talks"
        
        view.addSubview(header)
        mytableview = setTable()
        view.addSubview(mytableview!)
        setupLayout()
        
        talkListModel = talklistModel()
        talkListModel?.delegate = self
        
        mytableview?.tableFooterView = UIView()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        talkListModel?.getchatsdata()
    }
    
    let header :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hue: 0.4222, saturation: 0.61, brightness: 0.8, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    @objc func addTapped(){
        navigationController?.pushViewController(addfriendViewController(), animated: true)
    }
    
    
    private func setTable() -> UITableView {
        let myTableView = UITableView()
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.register(talklistcell.self, forCellReuseIdentifier: "talklistcell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.backgroundColor = ColorHolder.background

        
        return myTableView
    }
    
    private func setupLayout(){
        let navbarheight = (navigationController?.navigationBar.frame.height)!
        
        mytableview?.topAnchor.constraint(equalTo: view.topAnchor, constant: navbarheight).isActive = true
        mytableview?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mytableview?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mytableview?.bottomAnchor.constraint(equalTo:view.bottomAnchor ).isActive = true
    }
    
    
}

extension UITableViewCell {
func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.borderColor = UIColor.darkGray.cgColor
    border.borderWidth = width
     self.layer.masksToBounds = false
   
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: self.bounds.height , width: frame.size.width, height: width)
    self.layer.addSublayer(border)
}
}
