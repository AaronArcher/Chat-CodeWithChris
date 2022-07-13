//
//  TextHelper.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 13/07/2022.
//

import Foundation

class TextHelper {
    
    static func sanitizePhoneNumber(_ phone: String) -> String {
        return phone
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")

        
    }
    
}
