//
//  Hittable.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/13.
//

import Foundation

class HitRecord {
    public var p: Vec3
    public var outward_normal: Vec3
    public var t: Double
    public var normal: Vec3
    public var front_face: Bool
    public var mat: Material
    
    init(p: Vec3, outward_normal: Vec3, t: Double, mat: Material) {
        self.p = p
        self.outward_normal = outward_normal
        self.t = t
        self.mat = mat
        self.normal = Vec3()
        self.front_face = true
    }
    
    func set_face_normal(ray: Ray) {
        front_face = Vec3.dot(ray.direction, outward_normal) < 0
        normal = front_face ? outward_normal : -outward_normal
    }
}

protocol Hittable {
    func hit(ray: Ray, interval: Interval) -> HitRecord?
}

struct HittableList : Hittable{
    var items: [Hittable] = []
    
    mutating func add(item: Hittable) {
        items.append(item)
    }
    
    mutating func clear() {
        items = []
    }
    
    public func hit(ray: Ray, interval: Interval) -> HitRecord? {
        var ret: HitRecord? = nil
        var closest_so_far = interval.max
        for item in items {
            if let tmp = item.hit(ray: ray, interval: Interval(min: interval.min, max: closest_so_far)) {
                ret = tmp
                closest_so_far = tmp.t
            }
        }
        return ret
    }
}


class Sphere: Hittable {
    
    var center: Vec3
    var radius: Double
    var mat: Material
    
    init(center: Vec3, radius: Double, mat: Material) {
        self.center = center
        self.radius = radius
        self.mat = mat
    }
    
    public func hit(ray: Ray, interval: Interval) -> HitRecord? {
        let a = ray.direction.length_2
        let half_b = Vec3.dot(ray.direction, ray.origin - center)
        let c = (ray.origin - center).length_2 - radius * radius
        let delta = half_b * half_b - a * c
        if delta < 0 {
            return nil
        }
        var root = (-half_b - sqrt(delta)) / a
        if !interval.surrounds(x: root) {
            root = (-half_b + sqrt(delta)) / a
            if !interval.surrounds(x: root) {
                return nil
            }
        }
        let ret = HitRecord(p: ray.at(t: root), outward_normal: (ray.at(t: root) - center) / radius, t: root, mat: mat)
        ret.set_face_normal(ray: ray)
        return ret
    }
    
    
}
