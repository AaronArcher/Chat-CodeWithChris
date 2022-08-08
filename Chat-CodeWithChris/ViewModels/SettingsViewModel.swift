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
    
}
