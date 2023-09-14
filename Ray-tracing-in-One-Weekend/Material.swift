//
//  Material.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/14.
//

import Foundation

protocol Material {
    func scatter(ray_in: Ray, rec: HitRecord, attenuation: inout Color) -> Ray?
}

class Lambertian: Material {
    var albedo: Color
    
    init(albedo: Color) {
        self.albedo = albedo
    }
    
    func scatter(ray_in: Ray, rec: HitRecord, attenuation: inout Color) -> Ray? {
        var direction = rec.normal + Vec3.randomUnitVec()
        if direction.near_zero {
            direction = rec.normal
        }
        attenuation = albedo
        return Ray(origin: rec.p, direction: direction)
    }
    
    
}


class Metal: Material {

    var albedo: Color
    var fuzz: Double
    
    init(albedo: Color, fuzz: Double) {
        self.albedo = albedo
        self.fuzz = fuzz < 1 ? fuzz : 1
    }
    
    func scatter(ray_in: Ray, rec: HitRecord, attenuation: inout Color) -> Ray? {
        let direction = Vec3.mirrorRefect(in_direction: ray_in.direction, normal: rec.normal)
        attenuation = albedo
        let ret = Ray(origin: rec.p, direction: direction + fuzz * Vec3.randomUnitVec())
        if Vec3.dot(ret.direction, rec.normal) > 0 {
            return ret
        }
        return nil
    }
    
}

class Dielectric: Material {
    var ir: Double
    init(ir: Double) {
        self.ir = ir
    }
    
    func scatter(ray_in: Ray, rec: HitRecord, attenuation: inout Color) -> Ray? {
        attenuation = Color(1, 1, 1)
        let refraction_ratio = rec.front_face ? (1 / ir) : ir
        let unit_direction = ray_in.direction.normalized()
        let unit_normal = rec.normal.normalized()
        let cos_theta = min(Vec3.dot(-unit_direction, unit_normal), 1.0)
        let sin_theta = sqrt(1 - cos_theta * cos_theta)
        
        if (sin_theta * refraction_ratio > 1) || (Dielectric.reflectance(cosine: cos_theta, rr: refraction_ratio) > Utils.randomDouble()) {
            return Ray(origin: rec.p, direction: Vec3.mirrorRefect(in_direction: ray_in.direction, normal: rec.normal))
        } else {
            return Ray(origin: rec.p, direction: Vec3.refract(in_direction: unit_direction, normal: unit_normal, etat: refraction_ratio))
        }
        
    }
    
    static func reflectance(cosine: Double, rr: Double) -> Double {
        var r0 = (1 - rr) / (1 + rr)
        r0 = r0 * r0
        return r0 + (1 - r0) * pow((1 - cosine), 5)
    }
    
}
