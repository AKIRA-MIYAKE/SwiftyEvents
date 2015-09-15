//
//  SubClassingTests.swift
//  SwiftyEvents
//
//  Created by MiyakeAkira on 2015/08/16.
//  Copyright © 2015年 Miyake Akira. All rights reserved.
//

import XCTest
import SwiftyEvents

class SubClassingTests: XCTestCase {

    class SubEventEmitter: EventEmitter<String, String> {
        
        var prop: String = "" {
            didSet {
                emit("DidUpdate", value: prop)
            }
        }
        
    }
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSubClassing() {
        let expectation = expectationWithDescription("Emit to listeneres")
        
        let emitter = SubEventEmitter()
        let event = "DidUpdate"
        
        emitter.on(event) { (value) -> Void in
            expectation.fulfill()
            XCTAssertEqual(value, "Updated")
        }
        
        emitter.prop = "Updated"
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }

}
