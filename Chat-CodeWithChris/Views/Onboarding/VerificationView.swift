//
//  VerificationView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import SwiftUI

struct VerificationView: View {
    
    @Binding var currentStep: OnboardingStep

    @State private var verificationCode = ""
    
    var body: some View {

        VStack {
            
            Text("Verification")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Enter the 6 digit verification code we sent to your device.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            // Textfield
            ZStack {
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("input"))
                    .cornerRadius(5)
               
                TextField("", text: $verificationCode)
                    .font(Font.bodyParagraph)
                
            }
            .padding(.top, 34)
            
            Spacer()
            
            Button {
                // Next Step
                currentStep = .profile
                
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)

            
        }
        .padding(.horizontal)

    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification))
    }
}
