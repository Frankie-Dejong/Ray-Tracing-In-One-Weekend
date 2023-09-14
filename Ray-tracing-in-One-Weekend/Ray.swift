//
//  Ray.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/12.
//

import Foundation

class Ray {
    var origin: Vec3
    var direction: Vec3
    
    init(origin: Vec3, direction: Vec3) {
        self.origin = origin
        self.direction = direction
    }
    
    public func at(t: Double)->Vec3 {
        return origin + t * direction
    }
    

}
