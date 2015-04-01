//
//  Listener.swift
//  SwiftyEvents
//
//  Created by MiyakeAkira on 2015/04/01.
//  Copyright (c) 2015年 Miyake Akira. All rights reserved.
//

import Foundation

public class Listener<Argument: Any>: Equatable {
    
    // MARK: - let
    
    private let identifier: String
    private let function: Argument -> Void
    
    
    // MARK: - Initialize
    
    public init(function: Argument -> Void) {
        self.identifier = NSUUID().UUIDString
        self.function = function
    }
    
    
    // MARK: - Method
    
    public func exec(argument: Argument) {
        function(argument)
    }
    
}

public func ==<T>(lhs: Listener<T>, rhs: Listener<T>) -> Bool {
    return lhs.identifier == rhs.identifier
}