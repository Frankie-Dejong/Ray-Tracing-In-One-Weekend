//
//  main.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/11.
//

import Foundation


extension Color {
    public static func randomColor() -> Color {
        let a = Vec3.random()
        let b = Vec3.random()
        let c = a * b
        return Color(c.x, c.y, c.z)
    }
    
    public static func randomColor(min: Double, max: Double) -> Color {
        let a = Vec3.random(min: min, max: max)
        return Color(a.x, a.y, a.z)
    }
}


func main() {

    
    let material_ground = Lambertian(albedo: Color(0.5, 0.5, 0.5))

    var world = HittableList()
    world.add(item: Sphere(center: Vec3(0, -1000, 0), radius: 1000, mat: material_ground))
    
    for a in -11 ..< 11 {
        for b in -11 ..< 11 {
            let mat_choice = Utils.randomDouble()
            let center = Vec3(Double(a) + 0.9 * Utils.randomDouble(), 0.2, Double(b) + 0.9 * Utils.randomDouble())
            if (center - Vec3(4, 0.2, 0)).norm > 0.9 {
                if mat_choice < 0.8 {
                    world.add(item: Sphere(center: center,
                                           radius: 0.2,
                                           mat: Lambertian(albedo: Color.randomColor())))
                } else if mat_choice < 0.95 {
                    world.add(item: Sphere(center: center,
                                           radius: 0.2,
                                           mat: Metal(albedo: Color.randomColor(min: 0.5, max: 1),
                                                      fuzz: Utils.randomDouble(min: 0, max: 0.5))))
                } else {
                    world.add(item: Sphere(center: center,
                                           radius: 0.2,
                                           mat: Dielectric(ir: 1.5)))
                }
            }
        }
    }
    
    
    world.add(item: Sphere(center: Vec3(0, 1, 0),
                           radius: 1.0,
                           mat: Dielectric(ir: 1.5)))
    
    world.add(item: Sphere(center: Vec3(-4, 1, 0),
                           radius: 1.0,
                           mat: Lambertian(albedo: Color(0.4, 0.2, 0.1))))
    
    world.add(item: Sphere(center: Vec3(4, 1, 0),
                           radius: 1.0,
                           mat: Metal(albedo: Color(0.7, 0.6, 0.5), fuzz: 0)))
    
    

    Camera.render(world: world)
    
}

main()
 
