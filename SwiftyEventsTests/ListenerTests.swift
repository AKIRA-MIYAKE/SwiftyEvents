//
//  ListenerTests.swift
//  SwiftyEvents
//
//  Created by MiyakeAkira on 2015/04/02.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import UIKit
import XCTest
import SwiftyEvents

class ListenerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEquatable() {
        let f = { (str: String) -> Void in
            println(str)
        }
        
        let la = Listener(function: f)
        let lb = la
        
        let lc = Listener(function: f)
        
        XCTAssertEqual(la, lb, "Expect equal")
        XCTAssertNotEqual(la, lc, "Expect not equal")
    }
    
    func testEquatableInArray() {
        let f = { (str: String) -> Void in
            println(str)
        }
        
        let la = Listener(function: f)
        let lb = Listener(function: f)
        
        let arr = [la, lb]
        
        let lc = arr[1]
        
        XCTAssertEqual(la, arr[0], "Expect equal")
        XCTAssertEqual(lb, arr[1], "Expect equal")
        XCTAssertEqual(lb, lc, "Expect equal")
    }
    
    func testExec() {
        let expectation = self.expectationWithDescription("Execute function")
        
        let arg = "Argument"
        
        let f = { (argument: String) -> Void in
            expectation.fulfill()
            XCTAssertEqual(arg, argument, "Call function with argument")
        }
        let la = Listener(function: f)
        
        la.exec(arg)
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }

}
