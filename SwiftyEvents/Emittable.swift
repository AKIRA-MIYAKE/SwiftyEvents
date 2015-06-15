//
//  Emittable.swift
//  SwiftyEvents
//
//  Created by MiyakeAkira on 2015/04/01.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public protocol Emittable {
    typealias EventType: Hashable
    typealias ValueType: Any
    typealias FunctionType = ValueType -> Void
    
    func on(event: EventType, _ function: FunctionType) -> Listener<ValueType>
    func on(event: EventType, listener: Listener<ValueType>) -> Listener<ValueType>
    
    func once(event: EventType, _ function: FunctionType) -> Listener<ValueType>
    
    func removeListener(event: EventType, listener: Listener<ValueType>) -> Void
    func removeAllListeners() -> Void
    func removeAllListeners(events: [EventType]) -> Void
    
    func listeners(event: EventType) -> [Listener<ValueType>]
    
    func emit(event: EventType, value: ValueType) -> Bool
    
    func newListener(function: FunctionType) -> Listener<ValueType>
}