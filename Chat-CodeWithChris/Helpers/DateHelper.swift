//
//  DateHelper.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 20/07/2022.
//

import Foundation

class DateHelper {
    
    static func chatTimestampFrom(date: Date?) -> String {

        guard date != nil else { return "" }

        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        
        return df.string(from: date!)
        
    }
    
}
