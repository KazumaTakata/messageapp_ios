//
//  addfriendViewController.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/25.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import UIKit
import SwiftyJSON

class addfriendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorHolder.background
        view.addSubview(scrollview)
        
        scrollview.addSubview(viewcontainer)
        viewcontainer.addArrangedSubview(inputfieldcontainer)
        viewcontainer.addArrangedSubview(resultpiccontainer)
        viewcontainer.addArrangedSubview(addbuttoncontainer)
        viewcontainer.distribution = .fillEqually
        viewcontainer.axis = .vertical
        
        inputfieldcontainer.addSubview(friendnamefield)
        inputfieldcontainer.addSubview(idtextbutton)
        resultpiccontainer.addSubview(resultimage)
        resultpiccontainer.addSubview(resultname)
        
        addbuttoncontainer.addSubview(addbutton)
        
        scrollview.contentSize.height = 500
        
        
        
        setlayout()
    }
    
    var friendId :String?
    var friendIds: [String]?
    
    @objc func senduserId(){
        let friendname = friendnamefield.text!
        if friendname != "" {
            
            if (friendname != globalState.myname){

                requestServer.getRequest(url: "find/\(friendname)", completion: { json in
                    
                    if ( json["id"].string != nil ){
                        DispatchQueue.main.async {
                            let imgurl = json["photourl"].string!
                            let url = URL(string: imgurl)
                            let data = try? Data(contentsOf: url!)
                            self.resultimage.image = UIImage(data: data!)
                            self.resultname.text = json["name"].string!
                            self.friendId = json["id"].string!
                        }
                    } else {
                        let alert = showalert(title: "warning", message: "No Friend Found")
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                })
            } else {
                print("this is your name")
                let alert = showalert(title: "warning", message: "This is your name")
                DispatchQueue.main.async {
                    self.present(alert , animated: true, completion: nil)
                }
            }
        } else {
            
            let alert = showalert(title: "warning", message: "empty is not allowed")
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    let viewcontainer: UIStackView = {
        let uiview = UIStackView()
        uiview.translatesAutoresizingMaskIntoConstraints = false

        return uiview
    }()
    
    let scrollview: UIScrollView = {
        let uiscrollview = UIScrollView()
        uiscrollview.translatesAutoresizingMaskIntoConstraints = false
            
        return uiscrollview
    }()
    
    let inputfieldcontainer: UIView = {
        let uiview = UIView()
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        
        return uiview
    }()
    let resultpiccontainer: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    let addbuttoncontainer: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    let friendnamefield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let idtextbutton: UIButton = {
        let uibutton = UIButton()
        uibutton.translatesAutoresizingMaskIntoConstraints = false
        uibutton.setImage(#imageLiteral(resourceName: "searchicon").withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        uibutton.tintColor = .white
        uibutton.addTarget(self, action: #selector(senduserId), for: .touchUpInside )
        
        return uibutton
    }()
    
    let resultimage: UIImageView = {
        let uiimage = UIImageView()
        uiimage.translatesAutoresizingMaskIntoConstraints = false
        uiimage.image = #imageLiteral(resourceName: "defaultprofile")
        uiimage.contentMode = UIViewContentMode.scaleAspectFill
        
        return uiimage
    }()
    
    let resultname: UILabel = {
        let uiname = UILabel()
        uiname.translatesAutoresizingMaskIntoConstraints = false
        uiname.text = "No selection"
        uiname.textColor = ColorHolder.textcolor
        uiname.textAlignment = .center
        return uiname
    }()
    
    let  addbutton: UIButton = {
        let uibutton = UIButton()
        uibutton.translatesAutoresizingMaskIntoConstraints = false
       
        uibutton.setTitle("add Friend", for: .normal)
        uibutton.layer.cornerRadius = 10
        uibutton.clipsToBounds = true
        uibutton.backgroundColor = ColorHolder.button
        uibutton.addTarget(self, action: #selector(addfriend), for: .touchUpInside)
        return uibutton
    }()
    
    @objc func addfriend(){
        if let friendId = self.friendId {
        
            if !(friendIds?.contains(friendId))! && friendId != "" {
                requestServer.getRequest(url: "/addfriend/\(friendId)", completion: { json in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            } else {
                
                let alert = showalert(title: "warning", message: "This person is already your friend")
                DispatchQueue.main.async {
                    self.present(alert , animated: true, completion: nil)
                }
            }
        } else {
            let alert = showalert(title: "warning", message: "No friend is Choosen")
            DispatchQueue.main.async {
                self.present(alert , animated: true, completion: nil)
            }
        }
    }
    
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
        textfield.textColor = UIColor.lightGray
        textfield.placeholder = placeholder
    }

    
    func setlayout(){
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
        
        
        
        viewcontainer.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 50).isActive = true
        viewcontainer.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor).isActive = true
        viewcontainer.heightAnchor.constraint(equalToConstant: 500).isActive = true
        viewcontainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
     
        friendnamefield.decorateSelf(placeholder: "friend name")
        
        friendnamefield.centerYAnchor.constraint(equalTo: inputfieldcontainer.centerYAnchor).isActive = true
        friendnamefield.rightAnchor.constraint(equalTo: inputfieldcontainer.rightAnchor, constant: -40).isActive = true
        friendnamefield.leftAnchor.constraint(equalTo: inputfieldcontainer.leftAnchor, constant: 30).isActive = true
        friendnamefield.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        idtextbutton.centerYAnchor.constraint(equalTo: inputfieldcontainer.centerYAnchor).isActive = true
        idtextbutton.rightAnchor.constraint(equalTo: inputfieldcontainer.rightAnchor, constant: -10).isActive = true
        idtextbutton.widthAnchor.constraint(equalToConstant: 30 ).isActive = true
        idtextbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        resultimage.topAnchor.constraint(equalTo: resultpiccontainer.topAnchor).isActive = true
        resultimage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resultimage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        resultimage.centerXAnchor.constraint(equalTo: resultpiccontainer.centerXAnchor).isActive = true
        resultimage.layer.cornerRadius = 50
        resultimage.clipsToBounds = true
        
        resultname.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resultname.rightAnchor.constraint(equalTo: resultpiccontainer.rightAnchor).isActive = true
        resultname.leftAnchor.constraint(equalTo: resultpiccontainer.leftAnchor).isActive = true
        resultname.topAnchor.constraint(equalTo: resultimage.bottomAnchor, constant: 20).isActive = true
        
        addbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addbutton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addbutton.centerXAnchor.constraint(equalTo: addbuttoncontainer.centerXAnchor).isActive = true
        addbutton.topAnchor.constraint(equalTo: addbuttoncontainer.topAnchor).isActive = true
        
    
        
        
    }



    
}
