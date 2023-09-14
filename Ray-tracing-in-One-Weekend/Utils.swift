//
//  Utils.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/13.
//

import Foundation

class Utils {
    public static var infinity = Double.infinity
    public static var pi = 3.1415926535897932385
    public static func degrees2Radians(degrees: Double) -> Double {
        return degrees * pi / 180
    }
    public static func randomDouble() -> Double {
        return Double(arc4random_uniform(1000000)) / 1000000
    }
    public static func randomDouble(min: Double, max: Double) -> Double {
        return min + (max - min) * randomDouble()
    }
}
