//
//  SettingsViewModel.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 08/08/2022.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @AppStorage(Constants.darkModeKey) var isDarkMode = false
    
    var databaseService = DatabaseService()
    
    func deactivateAccount(completion: @escaping () -> Void) {
        
        // Call the database service
        databaseService.deactivateAccount {
            
            // Deactivation is complete
            completion()
        }
    }
    
}
