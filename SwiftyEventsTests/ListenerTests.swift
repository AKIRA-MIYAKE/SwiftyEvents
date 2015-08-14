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
            print(str)
        }
        
        let la = Listener(function: f)
        let lb = la
        
        let lc = Listener(function: f)
        
        XCTAssertEqual(la, lb, "Expect equal")
        XCTAssertNotEqual(la, lc, "Expect not equal")
    }
    
    func testEquatableInArray() {
        let f = { (str: String) -> Void in
            print(str)
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
        
        let val = "Value"
        
        let f = { (value: String) -> Void in
            expectation.fulfill()
            XCTAssertEqual(val, value, "Call function with argument")
        }
        let la = Listener(function: f)
        
        la.exec(val)
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testArgumentTypes() {
        let la = Listener(function: { (value: Int) -> Void in
            XCTAssertEqual(1, value, "Call function with Int")
        })
        la.exec(1)
        
        let lb = Listener(function: { (value: CGRect) -> Void in
            XCTAssertEqual(CGRectMake(10, 10, 10, 10), value, "Call functin with Coordinate")
        })
        lb.exec(CGRectMake(10, 10, 10, 10))
        
        let lc = Listener(function: { (value: (Int) -> Int) -> Void in
            XCTAssertEqual(10, value(5), "Call function with Function")
        })
        let function = { (value: Int) -> Int in
            return value * 2
        }
        lc.exec(function)
    }

}
