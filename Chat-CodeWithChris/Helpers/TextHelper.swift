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
            .replacingOccurrences(of: "+", with: "")
        
    }
    
    // https://stackoverflow.com/questions/56476007/swiftui-textfield-max-length
    static func limitText(_ stringvar: inout String, _ limit: Int) {
        if (stringvar.count > limit) {
            stringvar = String(stringvar.prefix(limit))
        }
    }
    
    // https://stackoverflow.com/questions/32364055/formatting-phone-number-in-swift
    static func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
        
        // Limit characters to 17 to match this pattern  +# (###) ###-####
        if (stringvar.count > 17) {
            stringvar = String(stringvar.prefix(17))
        }
        
    }
}
