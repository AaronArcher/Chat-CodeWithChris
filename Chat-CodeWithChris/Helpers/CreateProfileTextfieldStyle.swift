//
//  CreateProfileTextfieldStyle.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import Foundation
import SwiftUI

struct CreateProfileTextfieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color("input"))
                .cornerRadius(8)
                .frame(height: 46)
            
            // This references the textfield
            configuration
                .font(Font.tabBar)
                .padding()
        }

        
    }
    
}
