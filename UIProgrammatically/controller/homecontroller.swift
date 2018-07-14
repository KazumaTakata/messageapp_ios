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

class  HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, feedmodelDelegate  {
    
    
    var feedmodel: feedlistModel?
    var friendId: String?
    var friendname: String?
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (feedmodel?.getfriendfeed(friendName: friendname!).count)! + 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row  == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedlistfirstcell", for: indexPath as IndexPath) as! feedlistfirstcell
            
            let friendname = globalState.idtonameandphotourl[friendId!]!["name"]
            let friendphotourl = globalState.idtonameandphotourl[friendId!]!["url"]
            let friendbackurl = globalState.idtonameandphotourl[friendId!]!["backgroundurl"]
            
            
            let url = URL(string:friendphotourl!)
            let photodata = try? Data(contentsOf: url!)
            cell.profilephoto.image = UIImage(data: photodata!)
            
            let mainphotourl = URL(string:friendbackurl!)
            let mainphotodata = try? Data(contentsOf: mainphotourl!)
            cell.mainphoto.image = UIImage(data: mainphotodata!)
            cell.profilename.text = friendname
            cell.backgroundColor = ColorHolder.background
            
            return cell
        } else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "feedlistcell", for: indexPath as IndexPath) as! feedlistcell
           
            let friendfeeddata = feedmodel?.getfriendfeed(friendName: friendname!)
            
            let url = URL(string:( friendfeeddata![indexPath.row - 1].profilephotourl) )
            let photodata = try? Data(contentsOf: url!)
            cell.profilephoto.image = UIImage(data: photodata!)
            
            let mainphotourl = URL(string:( friendfeeddata![indexPath.row - 1].mainphotourl))
            let mainphotodata = try? Data(contentsOf: mainphotourl!)
            
            cell.mainphoto.image = UIImage(data: mainphotodata!)
            
            cell.maintext.text = friendfeeddata![indexPath.row - 1].maintext
            cell.maintext.sizeToFit()
            cell.maintext.layoutIfNeeded()
            cell.profilename.text = friendfeeddata![indexPath.row - 1].profilename
            cell.backgroundColor = ColorHolder.background
            
            return cell
            
        }
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
        
        view.backgroundColor = .white
        navigationItem.title = "feeds"
        
        friendname = globalState.idtonameandphotourl[friendId!]?["name"]
        
        mytableview = setTable()

        view.addSubview(mytableview!)
        setupLayout()
        
        let rightbutton = UIButton()
        
        rightbutton.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        rightbutton.tintColor = self.view.tintColor
        rightbutton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightbutton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rightbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightbutton.addTarget(self , action: #selector(addTapped) , for: .touchUpInside )
        
        let rightnavbarItem = UIBarButtonItem(customView: rightbutton)
        
        navigationItem.rightBarButtonItem = rightnavbarItem
        
        feedmodel = feedlistModel()
        
        feedmodel?.delegate = self
        
        feedmodel?.getfeedsdata()
        
        
        
        mytableview?.tableFooterView = UIView()
    }
    
    func newfeeds() {
        DispatchQueue.main.async {
            self.mytableview?.reloadData()
        }
    }
    
    
    @objc func addTapped(){
        navigationController?.pushViewController(Feedinputcontroller() , animated: true)
    }
    
    
    private func setTable() -> UITableView {
        let myTableView = UITableView()
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.register(feedlistcell.self, forCellReuseIdentifier: "feedlistcell")
        myTableView.register(feedlistfirstcell.self, forCellReuseIdentifier: "feedlistfirstcell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.backgroundColor = ColorHolder.background
        return myTableView
    }
    
    private func setupLayout(){
        let navbarheight = navigationController?.navigationBar.frame.height
        
        
        mytableview?.topAnchor.constraint(equalTo: view.topAnchor, constant: navbarheight!).isActive = true
        mytableview?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mytableview?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mytableview?.bottomAnchor.constraint(equalTo:view.bottomAnchor ).isActive = true
    }
    
    
}
