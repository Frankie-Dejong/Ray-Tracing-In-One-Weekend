//
//  PPM.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/12.
//

import Foundation

class Config {
    
    //Image
    static var image_width = 1200
    static var aspect_ratio = 16.0 / 9.0
    static var image_height: Int {
        get {
            return (Double(image_width) / aspect_ratio) < 1 ? 1 : Int(Double(image_width) / aspect_ratio)
        }
    }
    
    static var ppm_head = "P3\n"+String(image_width)+" "+String(image_height)+"\n"+String(255)+"\n"
    
    static var file_name = "img.ppm"
    
    static func put_head() {
        print(ppm_head)
    }
    
    
    
    //Camera
    static var defocus_angle: Double = 0.6
    static var focus_dist: Double = 10
    static var look_from = Vec3(13, 2, 3)
    static var look_at = Vec3(0, 0, 0)
    static var vup = Vec3(0, 1, 0)
    static var w: Vec3 {
        get {
            (look_from - look_at).normalized()
        }
    }
    static var u: Vec3 {
        get {
            Vec3.cross(vup, w).normalized()
        }
    }
    static var v: Vec3 {
        get {
            Vec3.cross(w, u)
        }
    }
    static var defocus_disk_u: Vec3 {
        get {
            let defocus_radius = focus_dist * tan(Utils.degrees2Radians(degrees: defocus_angle) / 2)
            return u * defocus_radius
        }
    }
    static var defocus_disk_v: Vec3 {
        get {
            let defocus_radius = focus_dist * tan(Utils.degrees2Radians(degrees: defocus_angle) / 2)
            return v * defocus_radius
        }
    }
    static var fov: Double = 20
    static var theta: Double {
        get {
            Utils.degrees2Radians(degrees: fov)
        }
    }
    static var h: Double {
        get {
            tan(theta / 2)
        }
    }
    static var viewport_height: Double {
        get {
            2 * h * focus_dist
        }
    }
    static var viewport_width: Double {
        get {
            viewport_height * Double(image_width) / Double(image_height)
        }
    }

    static var camera_center = look_from
    static var viewport_u = viewport_width * u
    static var viewport_v = -viewport_height * v
    static var samples_per_pixel = 10
    static var max_depth = 50
    
    static var pixel_delta_u: Vec3 {
        get {
            return viewport_u / image_width
        }
    }
    
    static var pixel_delta_v: Vec3 {
        get {
            return viewport_v / image_height
        }
    }
    
    static var viewport_upper_left: Vec3 {
        get {
            var tmp = camera_center - focus_dist * w
            tmp = tmp - viewport_u / 2 - viewport_v / 2
            return tmp
        }
    }
    
    static var pixel_00_loc: Vec3 {
        get {
            return viewport_upper_left + pixel_delta_u / 2 + pixel_delta_v / 2
        }
    }
        
}

