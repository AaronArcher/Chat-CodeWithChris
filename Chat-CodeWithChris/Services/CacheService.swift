//
//  CacheService.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 25/07/2022.
//

import Foundation
import SwiftUI

class CacheService {
    
    // Stores the image components with URL string as key
    private static var imageCache = [String : Image]()
    
    /// Return cached image if it exists - Nil means the image hasn't cached yet
    static func getImage(forKey: String) -> Image? {
        return imageCache[forKey]
    }
    
    /// Stores the image component in cache with the given key
    static func setImage(image: Image, forKey: String) {
        imageCache[forKey] = image
    }
    
}
