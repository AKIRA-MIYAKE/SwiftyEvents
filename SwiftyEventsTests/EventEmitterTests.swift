//
//  EventEmitterTests.swift
//  SwiftyEvents
//
//  Created by MiyakeAkira on 2015/04/02.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import UIKit
import XCTest
import SwiftyEvents

class EventEmitterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testOnWithFunction() {
        let emitter = EventEmitter<String, String>()
        let event = "test"
        
        let fa = { (value: String) -> Void in
            println(value)
        }
        let fb = { (value: String) -> Void in
            println(value)
        }
        
        let la = emitter.on(event, fa)
        let lb = emitter.on(event, fb)
        
        XCTAssertEqual(emitter.listeners(event).count, 2, "Expect listeners is 2")
        XCTAssertEqual(emitter.listeners(event)[0], la, "Expect equal returned listener")
        XCTAssertEqual(emitter.listeners(event)[1], lb, "Expect equal returned listener")
    }
    
    func testOnWithListener() {
        let emitter = EventEmitter<String, String>()
        let event = "test"
        
        let la = Listener(function: { (value: String) -> Void in
            println(value)
        })
        
        let lb = Listener(function: { (value: String) -> Void in
            println(value)
        })
        
        emitter.on(event, listener: la)
        emitter.on(event, listener: lb)
        
        XCTAssertEqual(emitter.listeners(event).count, 2, "Expect listeners is 2")
        XCTAssertEqual(emitter.listeners(event)[0], la, "Expect equal returned listener")
        XCTAssertEqual(emitter.listeners(event)[1], lb, "Expect equal returned listener")
    }
    
    func testOnce() {
        let emitter = EventEmitter<String, String>()
        let event = "test"
        
        let fa = { (value: String) -> Void in
            println(value)
        }
        let fb = { (value: String) -> Void in
            println(value)
        }
        
        let la = emitter.once(event, fa)
        let lb = emitter.once(event, fb)
        
        XCTAssertEqual(emitter.listeners(event).count, 2, "Expect listeners' count is 2")
        XCTAssertEqual(emitter.listeners(event)[0], la, "Expect equal returned listener")
        XCTAssertEqual(emitter.listeners(event)[1], lb, "Expect equal returned listener")
    }
    
    func testRemoveListener() {
        let emitter = EventEmitter<String, String>()
        let event = "test"
        
        let fa = { (value: String) -> Void in
            println(value)
        }
        let fb = { (value: String) -> Void in
            println(value)
        }
        
        let la = emitter.on(event, fa)
        let lb = emitter.on(event, fb)
        
        emitter.removeListener(event, listener: la)
        
        XCTAssertEqual(emitter.listeners(event).count, 1, "Expect listeners' count is 1")
        XCTAssertEqual(lb, emitter.listeners(event)[0], "Expect listeners index 0 is lb")
        XCTAssertNotEqual(la, emitter.listeners(event)[0], "Expect listeners index 0 is lb")
    }
    
    func testRemoveAllListeners() {
        let emitter = EventEmitter<String, String>()
        let event = "test"
        
        let fa = { (value: String) -> Void in
            println(value)
        }
        let fb = { (value: String) -> Void in
            println(value)
        }
        
        let la = emitter.on(event, fa)
        let lb = emitter.on(event, fb)
        
        emitter.removeAllListeners()
        
        XCTAssertEqual(emitter.listeners(event).count, 0, "Expect listners is cleared")
    }
    
    func testRemoveAllListenersWithEvents() {
        let emitter = EventEmitter<String, String>()
        let event1 = "test1"
        let event2 = "test2"
        let event3 = "test3"
        
        let f = { (value: String) -> Void in
            println(value)
        }
        
        emitter.on("test1", f)
        emitter.on("test2", f)
        emitter.on("test3", f)
        
        emitter.removeAllListeners([event1, event2])
        
        XCTAssertEqual(emitter.listeners(event1).count, 0, "Expect event1's listeners is cleared")
        XCTAssertEqual(emitter.listeners(event2).count, 0, "Expect event2's listeners is cleared")
        XCTAssertEqual(emitter.listeners(event3).count, 1, "Expect event3's listeners is not cleared")
    }
    
    func testEmitListeners() {
        let ea = expectationWithDescription("Emit to listeneres")
        let eb = expectationWithDescription("Emit to listeneres")
        
        let emitter = EventEmitter<String, String>()
        let event = "test"
        let val = "Value"
        
        let fa = { (value: String) -> Void in
            ea.fulfill()
            XCTAssertEqual(val, value, "Call function with argument")
        }
        let fb = { (value: String) -> Void in
            eb.fulfill()
            XCTAssertEqual(val, value, "Call function with argument")
        }
        
        let la = emitter.on(event, fa)
        let lb = emitter.on(event, fb)
        
        emitter.emit(event, value: val)
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testEmitOnceListenre() {
        let emitter = EventEmitter<String, String>()
        let event = "test"
        let val = "Value"
        
        var ca = 0
        
        let fa = { (value: String) -> Void in
            ca++
            
            XCTAssertEqual(val, value, "Call function with argument")
        }
        
        var cb = 0
        
        let fb = { (value: String) -> Void in
            cb++
            
            XCTAssertEqual(val, value, "Call function with argument")
        }
        
        emitter.once(event, fa)
        emitter.on(event, fb)
        
        emitter.emit(event, value: val)
        XCTAssertEqual(ca, 1, "Expect increment counter")
        XCTAssertEqual(cb, 1, "Expect increment counter")
        
        emitter.emit(event, value: val)
        emitter.emit(event, value: val)
        XCTAssertEqual(ca, 1, "Expect not increment counter")
        XCTAssertEqual(cb, 3, "Expect increment counter")
    }
    
    func testEmitOnceListenerOuterExec() {
        let emitter = EventEmitter<String, Int>()
        let event = "test"
        
        let listener = emitter.once(event) { (argument: Int) -> Void in
            XCTAssert((argument == 0), "Call with listener's method")
            XCTAssert(!(argument == 1), "Call with listener's method")
        }
        
        listener.exec(0)
        emitter.emit(event, value: 1)
    }
    
}
