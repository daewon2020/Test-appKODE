//
//  ImageLoader.swift
//  Test-appKODE
//
//  Created by Константин Андреев on 14.08.2022.
//

import Foundation
import UIKit

class ImageLoader {
    static var shared = ImageLoader()
    
    private var cacheImages: NSCache<NSString, UIImage> = NSCache()
    
    private init() { }
    
    func getImageFromCache(for url: String) async -> UIImage? {
        if let avatar =  cacheImages.object(forKey: url as NSString) {
            return avatar
        } else {
            if let data = await NetworkManager.shared.fetchEmployeeAvatar(from: url) {
                guard let image = UIImage(data: data) else { return nil }
                cacheImages.setObject(image, forKey: url as NSString)
                return image
            }
        }
        return nil
    }
    
    func clearCache() {
        cacheImages = NSCache()
    }
}
