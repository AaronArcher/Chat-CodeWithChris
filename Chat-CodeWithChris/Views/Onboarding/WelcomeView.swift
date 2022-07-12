//
//  WelcomeView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var currentStep: OnboardingStep
    
    var body: some View {

        VStack {
            
            Spacer()
            
            Image("onboarding-welcome")

            Text("Welcome to Chat app")
                .font(Font.titleText)
                .padding(.top, 32)
            
            Text("A simple and fuss-free chat experience")
                .font(Font.bodyParagraph)
                .padding(.top, 8)
            
            Spacer()
            
            Button {
                // Next step
                currentStep = .phoneNumber
            } label: {
                    Text("Get Started")
            }
            .buttonStyle(OnboardingButtonStyle())
            
            Text("By tapping 'Get Started' you agree to our Privacy Policy")
                .font(Font.smallText)
                .padding(.top, 14)
                .padding(.bottom, 61)

            
        }
        .padding(.horizontal)

    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(currentStep: .constant(.welcome))
    }
}
