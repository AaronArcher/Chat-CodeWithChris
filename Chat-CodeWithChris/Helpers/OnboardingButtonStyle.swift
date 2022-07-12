//
//  OnboardingButtonStyle.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import Foundation
import SwiftUI

struct OnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
     
        ZStack {
            Rectangle()
                .frame(height: 50)
                .cornerRadius(4)
                .foregroundColor(Color("button-primary"))
            
            configuration.label
                .font(Font.button)
                .foregroundColor(Color("text-button"))
        }

        
    }
}
