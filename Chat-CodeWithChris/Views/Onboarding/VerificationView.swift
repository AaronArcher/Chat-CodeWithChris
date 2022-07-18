//
//  VerificationView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import SwiftUI
import Combine

struct VerificationView: View {
    
    @Binding var currentStep: OnboardingStep
    @Binding var isOnboarding: Bool

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
                    .keyboardType(.numberPad)
                    .onReceive(Just(verificationCode)) { _ in
                        TextHelper.limitText(&verificationCode, 6)
                    }
                    .padding(.horizontal)
                
            }
            .padding(.top, 34)
            
            Spacer()
            
            Button {
                // Send the code to firebase
                AuthViewModel.verifyCode(code: verificationCode) { error in
                    
                    if error == nil {
                        
                        // check if this user has a profile
                        DatabaseService().checkUserProfile { exists in
                            
                            if exists {
                                // End the onboarding
                                isOnboarding = false
                                
                            } else {
                                // Move to Profile Creation Step
                                currentStep = .profile
                            }
                                
                        }
                        
                        
                    } else {
                        // TODO: Show error message
                    }
                }
                
              
                
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
        VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(true))
    }
}
