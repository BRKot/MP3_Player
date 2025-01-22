//
//  UIIMageExtension.swift
//  MP3_Player
//
//  Created by Databriz on 22/01/2025.
//

import UIKit
import ImageIO

extension UIImage {
    static func animatedImage(withGIFNamed name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        
        return animatedImage(withGIFData: imageData)
    }
    
    static func animatedImage(withGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: Double = 0.0
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                let delaySeconds = UIImage.delayForImageAtIndex(i, source: source)
                duration += delaySeconds
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
    
    private static func delayForImageAtIndex(_ index: Int, source: CGImageSource) -> Double {
        var delay = 0.05
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer { gifPropertiesPointer.deallocate() }
        
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self
        )
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                to: AnyObject.self
            )
        }
        
        delay = delayObject as? Double ?? 0.1
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
}
