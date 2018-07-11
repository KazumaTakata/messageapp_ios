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

class  FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, feedmodelDelegate  {
    
    
    var feedmodel: feedlistModel?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (feedmodel?.feeddata.count)!
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedlistcell", for: indexPath as IndexPath) as! feedlistcell
        
        let url = URL(string:(feedmodel?.feeddata[indexPath.row].profilephotourl)!)
        let photodata = try? Data(contentsOf: url!)
        cell.profilephoto.image = UIImage(data: photodata!)
        
        let mainphotourl = URL(string:(feedmodel?.feeddata[indexPath.row].mainphotourl)!)
        let mainphotodata = try? Data(contentsOf: mainphotourl!)
        
        cell.mainphoto.image = UIImage(data: mainphotodata!)

        cell.maintext.text = feedmodel?.feeddata[indexPath.row].maintext
        cell.maintext.sizeToFit()
        cell.maintext.layoutIfNeeded()
        cell.profilename.text = feedmodel?.feeddata[indexPath.row].profilename
        cell.backgroundColor = ColorHolder.background
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
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
