//
//  EventEmitter.swift
//  SwiftyEvents
//
//  Created by MiyakeAkira on 2015/04/01.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public class EventEmitter<Event: Hashable, Value: Any>: Emittable {
    
    // MARK: - Typealias
    
    typealias EventType = Event
    typealias ValueType = Value
    typealias FunctionType = ValueType -> Void
    
    
    // MARK: - Variables
    
    private var _listenerDictionary: [EventType: [Listener<ValueType>]]
    
    
    // MARK: - Initialize
    
    public init() {
        _listenerDictionary = [:]
    }
    
    deinit {
        removeAllListeners()
    }
    
    
    // MARK: - Emittable
    
    public func on(event: EventType, _ function: FunctionType) -> Listener<ValueType> {
        let listener = newListener(function)
        
        return on(event, listener: listener)
    }
    
    public func on(event: EventType, listener: Listener<ValueType>) -> Listener<ValueType> {
        if let listeners = _listenerDictionary[event] {
            _listenerDictionary[event]?.append(listener)
        } else {
            _listenerDictionary[event] = [listener]
        }
        
        return listener
    }
    
    
    public func once(event: EventType, _ function: FunctionType) -> Listener<ValueType> {
        func newOnceFunction(function: FunctionType) -> FunctionType {
            var didFire = false
            
            return { (value: ValueType) -> Void in
                if !didFire {
                    function(value)
                    didFire = true
                }
            }
        }
        
        let onceFunction = newOnceFunction(function)
        let listener = newListener(onceFunction)
        
        return on(event, listener: listener)
    }
    
    
    public func removeListener(event: EventType, listener: Listener<ValueType>) {
        if let listeners = _listenerDictionary[event] {
            var index: Int?
            for (i, l) in enumerate(listeners) {
                if l == listener {
                    index = i
                }
            }
            
            if let index = index {
                _listenerDictionary[event]?.removeAtIndex(index)
            }
        }
    }
    
    public func removeAllListeners() {
        _listenerDictionary.removeAll(keepCapacity: false)
    }
    
    public func removeAllListeners(events: [EventType]) {
        for event in events {
            _listenerDictionary[event]?.removeAll(keepCapacity: false)
        }
    }
    
    
    public func listeners(event: EventType) -> [Listener<ValueType>] {
        if let listeners = _listenerDictionary[event] {
            return listeners
        } else {
            return []
        }
    }
    
    
    public func emit(event: EventType, value: ValueType) -> Bool {
        if let listeners = _listenerDictionary[event] {
            if listeners.count != 0 {
                for listener in listeners {
                    listener.exec(value)
                }
                
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    public func newListener(function: FunctionType) -> Listener<ValueType> {
        return Listener(function: function)
    }
    
}
