//
//  tabbarController.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/25.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import UIKit

class customtabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frieldListController = UINavigationController(rootViewController: FriendListviewController())
        
        frieldListController.tabBarItem.title = "friends"
        
        frieldListController.tabBarItem.image = #imageLiteral(resourceName: "user_group_man_woman")
        
        let talkListControllerIns = UINavigationController(rootViewController: talkListController())
        
        talkListControllerIns.tabBarItem.title = "talks"
        
        talkListControllerIns.tabBarItem.image = #imageLiteral(resourceName: "chat")
        
        let feedController = UINavigationController(rootViewController: FeedViewController())
        
        feedController.title = "feeds"
        feedController.tabBarItem.image =  #imageLiteral(resourceName: "news")
        
        viewControllers = [frieldListController ,talkListControllerIns, feedController]
    }
    
}
