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

struct feedcellstruct {
    var profilephotourl: String
    var profilename: String
    var mainphotourl: String
    var maintext: String
}


class feedlistModel {
    
    var feeddata = [feedcellstruct]()
    var delegate :feedmodelDelegate?
    
    init(){}
    
    func getfeedsdata(){
        
        let urlstring = "http://localhost:8181/api/feed"
        guard let Url = URL(string: urlstring) else { return }
        var request = URLRequest(url: Url)
        request.setValue(globalState.token, forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { (data, response
            , error) in
            do {
                let json = try JSON(data: data!)
                self.addToFeeddata(json: json)
                print(self.feeddata)
                self.delegate?.newfeeds?()
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    
    private func addToFeeddata(json: JSON){
        if json.count > 0 {
            for index in 0...json.count - 1 {
                let id = json[index]["userId"].string
                let nameandphoto = globalState.idtonameandphotourl[id!]
                feeddata.append( feedcellstruct(profilephotourl: nameandphoto!["url"]!, profilename: nameandphoto!["name"]!, mainphotourl: json[index]["photourl"].string!, maintext: json[index]["feedcontent"].string!) )
            }
        }
    }
    
    func getfriendfeed(friendName: String) -> [feedcellstruct] {
        return feeddata.filter { $0.profilename == friendName }
    }
}

@objc protocol feedmodelDelegate :class {
    @objc optional func newfeeds()
}
