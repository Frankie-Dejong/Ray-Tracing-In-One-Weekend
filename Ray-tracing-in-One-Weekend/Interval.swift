//
//  Interval.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/13.
//

import Foundation

class Interval {
    public var min, max: Double
    
    init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }
    
    //Empty for default
    init() {
        self.min = Utils.infinity
        self.max = -Utils.infinity
    }
    
    public func contains(x: Double) -> Bool {
        return x >= min && x <= max
    }
    
    public func surrounds(x: Double) -> Bool {
        return x > min && x < max
    }
    
    public func clamp(x: Double) -> Double {
        if x < min {
            return min
        }
        if x > max {
            return max
        }
        return x
    }
    
    public static var empty = Interval()
    public static var universe = Interval(min: -Utils.infinity, max: Utils.infinity)
    
}


