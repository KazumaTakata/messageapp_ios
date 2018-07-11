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

class  Feedinputcontroller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var choosenPhoto = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "feeds"
        
        view.addSubview(openalbumbotton)
        view.addSubview(sendpostbotton)
        view.addSubview(textinput)
        view.addSubview(photochoosenlabel)
        
        imagePicker.delegate = self
        setlayout()
    
    }
    
    let openalbumbotton: UIButton = {
        let uibotton = UIButton()
        uibotton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        uibotton.translatesAutoresizingMaskIntoConstraints = false
        uibotton.addTarget(self, action: #selector(openalbum), for: .touchUpInside)
        return uibotton
    }()
    
    let sendpostbotton: UIButton = {
        
        let uibotton = UIButton()
        uibotton.setTitle("SEND", for: .normal)
        uibotton.tintColor = UIColor.black
        uibotton.translatesAutoresizingMaskIntoConstraints = false
        uibotton.addTarget(self, action: #selector(sendfeed), for: .touchUpInside)
        uibotton.layer.cornerRadius = 10
        uibotton.clipsToBounds = true
        uibotton.backgroundColor = ColorHolder.button
        
        return uibotton
    }()
    
    let textinput: UITextView = {
        let uitextview = UITextView()
        uitextview.translatesAutoresizingMaskIntoConstraints = false
        return uitextview
    }()
    
    let photochoosenlabel: UILabel = {
        let uilabel = UILabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.text = ""
        return uilabel
    }()
    
    @objc func openalbum(){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func sendfeed(){
        requestWith(imageData: UIImagePNGRepresentation(choosenPhoto))
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        choosenPhoto = chosenImage
        let imageData = UIImagePNGRepresentation(choosenPhoto)!
        photochoosenlabel.text = "photo choosen"
//        requestWith(imageData: imageData)
        dismiss(animated: true, completion: nil)
    }
    
    func requestWith( imageData: Data?, onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = "http://localhost:8181/api/feed" /* your API url */
        let feedcontent = self.textinput.text!
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data",
            "x-access-token": globalState.token
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append("\(feedcontent)".data(using: String.Encoding.utf8)!, withName: "feedcontent")
    
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    self.view.makeToast("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    private func setlayout(){
        
        let navbarheight = (navigationController?.navigationBar.frame.height)!
        
        sendpostbotton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendpostbotton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sendpostbotton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendpostbotton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
//        sendpostbotton.backgroundColor = UIColor(hue: 0.4222, saturation: 0.61, brightness: 0.8, alpha: 1.0)
        
        openalbumbotton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        openalbumbotton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        openalbumbotton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openalbumbotton.bottomAnchor.constraint(equalTo: sendpostbotton.topAnchor, constant: -20).isActive = true
        
        photochoosenlabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        photochoosenlabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        photochoosenlabel.leftAnchor.constraint(equalTo: openalbumbotton.rightAnchor, constant: 5).isActive = true
        photochoosenlabel.bottomAnchor.constraint(equalTo: sendpostbotton.topAnchor, constant: -20).isActive = true
        
        textinput.topAnchor.constraint(equalTo: view.topAnchor, constant: navbarheight + 20 ).isActive = true
        textinput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textinput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        textinput.bottomAnchor.constraint(equalTo: openalbumbotton.topAnchor).isActive = true
        
    }
}
