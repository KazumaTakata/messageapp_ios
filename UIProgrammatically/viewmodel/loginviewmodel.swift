//
//  loginviewmodel.swift
//  UIProgrammatically
//
//  Created by Kazuma Takata on 2018/07/12.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import Foundation
import RxSwift

struct loginviewmodel {
    
    var name = Variable<String>("")
    var password = Variable<String>("")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(name.asObservable(), password.asObservable(), resultSelector: { (name, password) in
                return login_input_validation(name: name, password: password).success
        })
    }
}
