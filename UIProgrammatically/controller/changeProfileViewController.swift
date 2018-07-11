//
//  changeProfileViewController.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/02.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class changeProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker = UIImagePickerController()
    var imageplaceholder = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorHolder.background
        imagePicker.delegate = self
        
        view.addSubview(scrollview)
        
        scrollview.addSubview(profilephotoheader)
        scrollview.addSubview(profilePhoto)
        scrollview.addSubview(profilenameheader)
        scrollview.addSubview(currentnamelabel)
//        scrollview.addSubview(profilename)
//
        scrollview.addSubview(changenameinput)

        scrollview.addSubview(profilenameheader)
//
        scrollview.addSubview(setnamebutton)
    
        navigationItem.title = "profile"
        
       
        setlayout()
        
        setimage()
       
    }

    let profilePhoto: UIImageView = {
       let uiimageview = UIImageView()
       uiimageview.translatesAutoresizingMaskIntoConstraints = false
      
       uiimageview.makeround(circlesize: 100)
       return uiimageview
    }()
    
    
    let scrollview: UIScrollView = {
        let uiscrollview = UIScrollView()
        
        uiscrollview.translatesAutoresizingMaskIntoConstraints = false
        uiscrollview.contentSize.height = 500
        
        return uiscrollview
    }()
    
    let currentnamelabel: UILabel = {
        let uilabel = UILabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textAlignment = .center
        uilabel.textColor = ColorHolder.textcolor
        uilabel.text = "Your current name is \(globalState.myname)"
        return uilabel
    }()
    
    let changenameinput: UITextField = {
       let uitextfield = UITextField()
        uitextfield.translatesAutoresizingMaskIntoConstraints = false
        uitextfield.decorateSelf(placeholder: "name")
        
        return uitextfield
    }()
    
    let setnamebutton: UIButton = {
        let uibutton = UIButton()
        uibutton.translatesAutoresizingMaskIntoConstraints = false
        uibutton.setTitle("change name", for: .normal)
        uibutton.layer.cornerRadius = 10
        uibutton.clipsToBounds = true
        uibutton.backgroundColor = ColorHolder.button
        uibutton.addTarget(self, action: #selector(setname), for: .touchUpInside)
        return uibutton
    }()
    
    @objc func setname(){
        let newname = changenameinput.text!
        let parameters: Parameters = [
            "name": newname
        ]
        let headers: HTTPHeaders = [
            "x-access-token": globalState.token
        ]
        
        Alamofire.request("http://localhost:8181/api/profile/name", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            debugPrint(response)
          
            globalState.myname = newname
            self.currentnamelabel.text =  "Your current name is \(globalState.myname)"
        }
    }
    
    let choosenPhoto: UIImageView = {
        let uiimageview = UIImageView()
        uiimageview.translatesAutoresizingMaskIntoConstraints = false
       
        return uiimageview
    }()
    
    let profilename: UILabel = {
       let uilabel = UILabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textAlignment = .center
        uilabel.textColor = ColorHolder.textcolor
        return uilabel
    }()
    
    let profilephotoheader: UILabel = {
        let uilabel = PaddingLabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textAlignment = .center
        uilabel.textColor = ColorHolder.textcolor
        uilabel.backgroundColor = ColorHolder.headercolor
        uilabel.text = "change profile photo"
        return uilabel
    }()
    
    let profilenameheader: UILabel = {
        let uilabel = PaddingLabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textAlignment = .center
        uilabel.textColor = ColorHolder.textcolor
        uilabel.backgroundColor = ColorHolder.headercolor
        uilabel.text = "change name"
        return uilabel
    }()
    
    let passwordheader: UILabel = {
        let uilabel = PaddingLabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textAlignment = .center
        uilabel.textColor = ColorHolder.textcolor
        uilabel.backgroundColor = ColorHolder.headercolor
        uilabel.text = "change password"
        return uilabel
    }()


    
    
    @objc private func openalbum(){
        print("image clicked")
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
          
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    func requestWith( imageData: Data?, onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = "http://localhost:8181/api/profile/photo"
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "x-access-token": globalState.token
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        choosenPhoto.image = chosenImage
        let imageData = UIImagePNGRepresentation(choosenPhoto.image!)!
        requestWith(imageData: imageData)
        profilePhoto.image = choosenPhoto.image
        dismiss(animated: true, completion: nil)
    }
    
    private func setimage(){
        let urlstring = "http://localhost:8181/api/profile"
        guard let Url = URL(string: urlstring) else { return }
        var request = URLRequest(url: Url)
        request.setValue(globalState.token, forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { (data, response
            , error) in
            do {
                let json = try JSON(data: data!)
                let url_string = json["photourl"].string
                let url = URL(string: url_string! )
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.profilePhoto.image = UIImage(data: data!)
                    self.profilename.text = json["name"].string
                    self.profilename.sizeToFit()
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    private func setlayout(){
        let navbarheight = (navigationController?.navigationBar.frame.height)!
        
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
       
        
        profilephotoheader.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        profilephotoheader.widthAnchor.constraint(equalTo: scrollview.widthAnchor).isActive = true
        profilephotoheader.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilePhoto.topAnchor.constraint(equalTo: profilephotoheader.bottomAnchor , constant: 20).isActive = true
        profilePhoto.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openalbum))
        profilePhoto.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        profilePhoto.addGestureRecognizer(tap)

    
        profilenameheader.widthAnchor.constraint(equalTo: scrollview.widthAnchor).isActive = true
        profilenameheader.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 20).isActive = true
        profilenameheader.heightAnchor.constraint(equalToConstant:  50).isActive = true
    
        currentnamelabel.topAnchor.constraint(equalTo: profilenameheader.bottomAnchor, constant: 20).isActive = true
        currentnamelabel.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor).isActive = true

        currentnamelabel.heightAnchor.constraint(equalToConstant: 50).isActive = true


        changenameinput.topAnchor.constraint(equalTo: currentnamelabel.bottomAnchor, constant: 20).isActive = true
        changenameinput.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor).isActive = true
        changenameinput.widthAnchor.constraint(equalToConstant: 200).isActive = true
        changenameinput.heightAnchor.constraint(equalToConstant: 50).isActive = true

        setnamebutton.topAnchor.constraint(equalTo: changenameinput.bottomAnchor, constant: 20).isActive = true
        setnamebutton.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor).isActive = true
        setnamebutton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        setnamebutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        

        
    }
}

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}



