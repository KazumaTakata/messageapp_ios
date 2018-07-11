//
//  LoginTest.swift
//  UIProgrammaticallyTests
//
//  Created by Kazuma Takata on 2018/07/09.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import XCTest
@testable import UIProgrammatically

class LoginTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
 
    
    func test_login_input_validation(){
        
        // is input empty?
        
        let result0 = login_input_validation(name: "johnphp", password: "password")
        XCTAssertEqual(result0.success, true)
        
        let result1 = login_input_validation(name: "", password: "pass")
        XCTAssertEqual(result1.success, false)
        
        let result2 = login_input_validation(name: "john", password: "")
        XCTAssertEqual(result2.success, false)
        
        let result3 = login_input_validation(name: "", password: "")
        XCTAssertEqual(result3.success, false)
        
    
        // is input's length correct  name 3 < length < 10; password 3 < length < 10
    
        let result4 = login_input_validation(name: "q", password: "r")
        XCTAssertEqual(result4.success, false)
        
        let result5 = login_input_validation(name: "qqqqqqqqqqqqqq", password: "r")
        XCTAssertEqual(result5.success, false)
        
        let result6 = login_input_validation(name: "qqqqqqqq", password: "rrrrrrrrrrrrrrrrrrrr")
        XCTAssertEqual(result6.success, false)
        
        
        
        
    }
    
    
    
   
    
}
