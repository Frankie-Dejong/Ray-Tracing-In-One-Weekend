//
//  Vec3.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/11.
//

import Foundation

class Vec3 {
    
    public var x, y, z : Double
    
    public var cordinates : [Double]  {
        get {
            return [x, y, z]
        }
    }
    
    public var norm : Double {
        get {
            return sqrt(x * x + y * y + z * z)
        }
    }
    
    public var length_2 : Double {
        get {
            return x * x + y * y + z * z
        }
    }
    
    public var near_zero : Bool {
        get {
            let epsilon = 1e-8
            return abs(x) < epsilon && abs(y) < epsilon && abs(z) < epsilon
        }
    }
    
    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init?(_ cordinates : [Double]) {
        if cordinates.count != 3 {
            return nil
        }
        self.x = cordinates[0]
        self.y = cordinates[1]
        self.z = cordinates[2]
    }
    
    init() {
        self.x = 0
        self.y = 0
        self.z = 0
    }
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = Double(x)
        self.y = Double(y)
        self.z = Double(z)
    }
    
    static func + (_ vec1: Vec3, _ vec2: Vec3) -> Vec3 {
        return Vec3(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z)
    }
    
    static func - (_ vec1: Vec3, _ vec2: Vec3) -> Vec3 {
        return Vec3(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z)
    }
    
    
    static func - (_ vec1: Vec3, _ off: Double) -> Vec3 {
        return Vec3(vec1.x - off, vec1.y - off, vec1.z - off)
    }
    
    static prefix func - (_ vec1: Vec3) -> Vec3 {
        return Vec3(-vec1.x, -vec1.y, -vec1.z)
    }
    
    
    static func * (_ vec1: Vec3, _ vec2: Vec3) -> Vec3 {
        return Vec3(vec1.x * vec2.x, vec1.y * vec2.y, vec1.z * vec2.z)
    }
    
    static func * (_ vec1: Vec3, _ time: Double) -> Vec3 {
        return Vec3(vec1.x * time, vec1.y * time, vec1.z * time)
    }
    
    static func * (_ time: Double, _ vec1: Vec3) -> Vec3 {
        return Vec3(vec1.x * time, vec1.y * time, vec1.z * time)
    }
    
    static func / (_ vec1: Vec3, _ off: Double) -> Vec3 {
        return Vec3(vec1.x / off, vec1.y / off, vec1.z / off)
    }
    
    static func / (_ vec1: Vec3, _ off: Int) -> Vec3 {
        return Vec3(vec1.x / Double(off), vec1.y / Double(off), vec1.z / Double(off))
    }
    
    
    public static func normalize(_ vec1: Vec3) -> Vec3 {
        return vec1 / vec1.norm
        
    }
    
    public func normalized() -> Vec3 {
        return self / norm
    }
    
    public static func dot(_ vec1: Vec3, _ vec2: Vec3) -> Double {
        return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
    }
    
    public static func cross(_ vec1: Vec3, _ vec2: Vec3) -> Vec3 {
        return Vec3(vec1.y * vec2.z - vec1.z * vec2.y,
                    vec1.z * vec2.x - vec1.x * vec2.z,
                    vec1.x * vec2.y - vec1.y * vec2.x)
    }
    
    public static func random() -> Vec3 {
        return Vec3(Utils.randomDouble(), Utils.randomDouble(), Utils.randomDouble())
    }
    
    public static func random(min: Double, max: Double) -> Vec3 {
        return Vec3(Utils.randomDouble(min: min, max: max), Utils.randomDouble(min: min, max: max), Utils.randomDouble(min: min, max: max))
    }
    
    public static func randomInUnitSphere() -> Vec3 {
        while true {
            let p = random(min: -1, max: 1)
            if p.length_2 <= 1 {
                return p
            }
        }
    }
    
    public static func randomUnitVec() -> Vec3 {
        return random() .normalized()
    }
    
    public static func randomUnitVecOnHemiSphere(normal: Vec3) -> Vec3 {
        let ret = randomUnitVec()
        if dot(ret, normal) > 0 {
            return ret
        }
        return -ret
    }
    
    public static func mirrorRefect(in_direction: Vec3, normal: Vec3) -> Vec3 {
        return in_direction - 2 * dot(in_direction, normal) * normal
    }
    
    public static func refract(in_direction: Vec3, normal: Vec3, etat: Double) -> Vec3 {
        let cos_theta = min(Vec3.dot(-in_direction, normal), 1.0)
        let r_perp = etat * (in_direction + cos_theta * normal)
        let r_parl = -sqrt(abs(1 - r_perp.length_2)) * normal
        return r_perp + r_parl
    }
    
    public static func randomInUnitDisk() -> Vec3 {
        while true {
            let ret = Vec3(Utils.randomDouble(min: -1, max: 1), Utils.randomDouble(min: -1, max: 1), 0)
            if ret.length_2 <= 1 {
                return ret
            }
        }
    }
    
}

class Color : Vec3 {
    public var content: String {
        get {
            return "\(Int(255.999 * x)) \(Int(255.999 * y)) \(Int(255.999 * z))\n"
        }
    }
    
    static func gamma2(linear: Double) -> Double {
        return sqrt(linear)
    }
    
    public static func write_color(pixel: Color) {
        print("\(Int(255.999 * gamma2(linear: pixel.x))) \(Int(255.999 * gamma2(linear: pixel.y))) \(Int(255.999 * gamma2(linear: pixel.z)))")
    }
}




