//
//  EventEmitter.swift
//  SwiftyEvents
//
//  Created by MiyakeAkira on 2015/04/01.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public class EventEmitter<Event: Hashable, Argument: Any>: Emittable {
    
    // MARK: - Typealias
    
    typealias EventType = Event
    typealias ArgumentType = Argument
    typealias FunctionType = ArgumentType -> Void
    
    
    // MARK: - Variables
    
    private var _listenerDictionary: [EventType: [Listener<ArgumentType>]]
    
    
    // MARK: - Initialize
    
    public init() {
        _listenerDictionary = [:]
    }
    
    deinit {
        removeAllListeners()
    }
    
    
    // MARK: - Emittable
    
    public func on(event: EventType, _ function: FunctionType) -> Listener<ArgumentType> {
        let listener = newListener(function)
        
        return on(event, listener: listener)
    }
    
    public func on(event: EventType, listener: Listener<ArgumentType>) -> Listener<ArgumentType> {
        if let listeners = _listenerDictionary[event] {
            _listenerDictionary[event]?.append(listener)
        } else {
            _listenerDictionary[event] = [listener]
        }
        
        return listener
    }
    
    
    public func once(event: EventType, _ function: FunctionType) -> Listener<ArgumentType> {
        func newOnceFunction(function: FunctionType) -> FunctionType {
            var didFire = false
            
            return { (arg: ArgumentType) -> Void in
                if !didFire {
                    function(arg)
                    didFire = true
                }
            }
        }
        
        let onceFunction = newOnceFunction(function)
        let listener = newListener(onceFunction)
        
        return on(event, listener: listener)
    }
    
    
    public func removeListener(event: EventType, listener: Listener<ArgumentType>) {
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
    
    
    public func listeners(event: EventType) -> [Listener<ArgumentType>] {
        if let listeners = _listenerDictionary[event] {
            return listeners
        } else {
            return []
        }
    }
    
    
    public func emit(event: EventType, argument: ArgumentType) -> Bool {
        if let listeners = _listenerDictionary[event] {
            if listeners.count != 0 {
                for listener in listeners {
                    listener.exec(argument)
                }
                
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    public func newListener(function: FunctionType) -> Listener<ArgumentType> {
        return Listener(function: function)
    }
    
}
