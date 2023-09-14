//
//  Camera.swift
//  Ray-tracing-in-One-Weekend
//
//  Created by mac on 2023/9/14.
//

import Foundation

extension Color {
    public static func + (_ vec1: Color, _ vec2: Color) -> Color {
        return Color(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z)
    }
    
    public static func * (_ vec1: Color, _ time: Double) -> Color {
        return Color(vec1.x * time, vec1.y * time, vec1.z * time)
    }
    
    public static func * (_ time: Double, _ vec1: Color) -> Color {
        return Color(vec1.x * time, vec1.y * time, vec1.z * time)
    }
    
    public static func * (_ vec1: Color, _ vec2: Color) -> Color {
        return Color(vec1.x * vec2.x, vec1.y * vec2.y, vec1.z * vec2.z)
    }
    
    public static func / (color: Color, n: Double) -> Color {
        return Color(color.x / n, color.y / n, color.z / n)
    }
}

class Camera {
    
    
    public static func render(world: Hittable) {
        var pixel_colors: [[Color]] = []
        
        for j in 0 ..< Config.image_height {
            print("ScanLines remaining \(Config.image_height - j)")
            pixel_colors.append([])
            for i in 0 ..< Config.image_width {
                var pixel_color = Color()
                for _ in 0 ..< Config.samples_per_pixel {
                    let ray = getRay(i: i, j: j)
                    pixel_color = pixel_color + rayColor(ray: ray, depth: Config.max_depth, world: world)
                }
                pixel_color = pixel_color / Double(Config.samples_per_pixel)
                pixel_colors[j].append(pixel_color)
            }
        }
        
        output_Img(pixel_colors: pixel_colors)
    }
    
    
    private static func getRay(i: Int, j: Int) -> Ray {
        let pixel_center = Config.pixel_00_loc + (Double(i) * Config.pixel_delta_u) + (Double(j) * Config.pixel_delta_v)
        let sample_point = pixel_center + (Utils.randomDouble() - 0.5) * Config.pixel_delta_u + (Utils.randomDouble() - 0.5) * Config.pixel_delta_v
        let origin = (Config.defocus_angle <= 0) ? Config.camera_center : defocusDiskSample()
        let ray_direction = sample_point - origin
        return Ray(origin: origin, direction: ray_direction)
    }
    
    private static func defocusDiskSample() -> Vec3 {
        let p = Vec3.randomInUnitDisk()
        return Config.camera_center + p.x * Config.defocus_disk_u + p.y * Config.defocus_disk_v
    }
    
    private static func output_Img(pixel_colors: [[Color]]) {
        
        let fileName = Config.file_name
        let fileManager = FileManager.default
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask,
                                                       true).first
        let path = file!+"/Ray-tracing-in-One-Weekend/"+fileName
        fileManager.createFile(atPath: path, contents: nil)
        let handle = FileHandle(forWritingAtPath: path)
        
        if handle == nil {
            print("File Not Found")
            return
        }
        
        try? handle!.write(contentsOf: Config.ppm_head.data(using: String.Encoding.utf8)!)

        for j in 0 ..< Config.image_height {
            for i in 0 ..< Config.image_width {
                let pixel_color = pixel_colors[j][i]
                try? handle?.write(contentsOf: pixel_color.content.data(using: String.Encoding.utf8)!)
            }
        }
        print("Done! check at "+path)
        try? handle?.close()
        
    }
    
    private static func rayColor(ray: Ray, depth: Int, world: Hittable) -> Color {
        if depth <= 0 {
            return Color()
        }
        if let rec = world.hit(ray: ray, interval: Interval(min: 0.001, max: Utils.infinity)) {
            var attenuation = Color()
            if let scattered = rec.mat.scatter(ray_in: ray, rec: rec, attenuation: &attenuation) {
                return attenuation * rayColor(ray: scattered, depth: depth - 1, world: world)
            }
            return attenuation
        }
        let unit = ray.direction.normalized()
        let a = 0.5 * (unit.y + 1)
        return (1 - a) * Color(1, 1, 1) + a * Color(0.5, 0.7, 1)
    }
}
