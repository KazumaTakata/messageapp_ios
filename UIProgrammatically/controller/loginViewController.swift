//
//  loginViewController.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/06/24.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RxSwift
import RxCocoa

//test
//test2

class loginViewController: UIViewController {

    var messageSocket: MessageWebSocket?
    var inputIsValid: Bool = false

    var viewmodel = loginviewmodel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorHolder.background
        view.addSubview(login_input_container)

        login_input_container.addArrangedSubview(title_label)
        login_input_container.addArrangedSubview(login_input_name)
        login_input_container.addArrangedSubview(login_input_password)
        login_input_container.addArrangedSubview(login_button)
        
        bindToView()
    
        setlayout()
    }
    
    func bindToView(){
        _ = login_input_name.rx.text.map({value in value!}).bind(to: viewmodel.name )
        _ = login_input_password.rx.text.map({value in value!}).bind(to: viewmodel.password)
        _ = viewmodel.isValid.subscribe(onNext: { isvalid in self.inputIsValid = isvalid })
    }
    
    let login_input_container: UIStackView = {
        let uiview = UIStackView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.axis = UILayoutConstraintAxis.vertical
        uiview.distribution  = UIStackViewDistribution.fillEqually
        uiview.spacing = 10
        return uiview
    }()
    
    let login_input_name: UITextField = {
        let uitextfiled = UITextField()
        uitextfiled.placeholder = "name"
        uitextfiled.translatesAutoresizingMaskIntoConstraints = false
        return uitextfiled
    }()
    
    let login_input_password: UITextField = {
        let uitextfield = UITextField()
        uitextfield.translatesAutoresizingMaskIntoConstraints = false
        return uitextfield
    }()
    
    let title_label: UILabel = {
        let uilabel = UILabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.text = "Messenger"
        uilabel.font = UIFont.systemFont(ofSize: 30)
        uilabel.textColor = UIColor.white
        uilabel.addCharactersSpacing(4)
        return uilabel
    }()
    
    let login_button: UIButton = {
        let uibutton = UIButton()
        uibutton.translatesAutoresizingMaskIntoConstraints = false
        uibutton.setTitle("START", for: .normal)
        uibutton.clipsToBounds = true
        uibutton.layer.borderColor = UIColor.white.cgColor
        uibutton.layer.borderWidth = 1
        uibutton.layer.cornerRadius = 10
        uibutton.addTarget(self, action: #selector(loginPushed), for: .touchUpInside)
        
        return uibutton
    }()
    

    @objc func loginPushed(){
        
        if inputIsValid {
            
            let postdata = ["name": viewmodel.name.value, "password": viewmodel.password.value ]
            
            let url = "http://localhost:8181/api/login/"
            guard let Url = URL(string: url) else { return }
            
            Alamofire.request(Url, method:.post, parameters: postdata, encoding: JSONEncoding.default ).responseJSON { (res) in
                self.handlerequestreturn(res: res)
            }
        } else {
            let alert = showalert(title: textcontainer.alert_invalid_input_title, message:textcontainer.alert_invalid_input_message)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func handlerequestreturn(res: DataResponse<Any>){
        switch res.result {
        case .success(let value):
            let json = JSON(value)
            if json["login"].bool! {
                let token = json["token"].string
                let myId = json["id"].string
                let name = json["name"].string
                globalState.token = token!
                globalState.myId = myId!
                globalState.myname = name!
                
                DispatchQueue.main.async {
                    self.present(customtabbarController() , animated: true, completion: nil)
                }
            } else {
                let alert = showalert(title: textcontainer.alert_fail_login_title, message: textcontainer.alert_fail_login_message )
                self.present(alert, animated: true, completion: nil)
            }
        case .failure(let error):
            print(error)
        }
        
    }
   
    
    func setlayout(){
        login_input_container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        login_input_container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        login_input_container.heightAnchor.constraint(equalToConstant: 300).isActive = true
        login_input_container.widthAnchor.constraint(equalToConstant: 300).isActive = true


        login_input_name.decorateSelf(placeholder: "name")
        login_input_password.decorateSelf(placeholder: "password")
        
        
    }
}



