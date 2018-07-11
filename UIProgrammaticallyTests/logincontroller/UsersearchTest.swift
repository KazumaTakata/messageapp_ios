//
//  UsersearchTest.swift
//  UIProgrammaticallyTests
//
//  Created by Kazuma Takata on 2018/07/10.
//  Copyright © 2018 Kazuma Takata. All rights reserved.
//

import XCTest
@testable import UIProgrammatically

class UsersearchTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_UserIdvalidation(){
        
        // length of userId should be 24
        
        let userIdvalid = userId_input_validation(userId: "eeeeeeee")
        
        XCTAssertEqual(userIdvalid, false)
        
        let userIdvalid2 = userId_input_validation(userId: "eeeeeeeeeeeeeeeeeeeeeeee")
        
        XCTAssertEqual(userIdvalid2, true)
        
        
    }
    
    
    
}
