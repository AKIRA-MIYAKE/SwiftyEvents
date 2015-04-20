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
    typealias ArgumentType: Any
    typealias FunctionType = ArgumentType -> Void
    
    func on(event: EventType, _ function: FunctionType) -> Listener<ArgumentType>
    func on(event: EventType, listener: Listener<ArgumentType>) -> Listener<ArgumentType>
    
    func once(event: EventType, _ function: FunctionType) -> Listener<ArgumentType>
    
    func removeListener(event: EventType, listener: Listener<ArgumentType>) -> Void
    func removeAllListeners() -> Void
    func removeAllListeners(events: [EventType]) -> Void
    
    func listeners(event: EventType) -> [Listener<ArgumentType>]
    
    func emit(event: EventType, argument: ArgumentType) -> Bool
    
    func newListener(function: FunctionType) -> Listener<ArgumentType>
}