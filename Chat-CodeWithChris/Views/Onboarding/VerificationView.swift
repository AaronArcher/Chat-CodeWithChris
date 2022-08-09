//
//  VerificationView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import SwiftUI
import Combine

struct VerificationView: View {

    @EnvironmentObject var contactsViewModel: ContactsViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    @Binding var currentStep: OnboardingStep
    @Binding var isOnboarding: Bool
    
    @State private var verificationCode = ""
    
    @State private var isButtonDisabled = false
    
    @State private var isErrorVisible = false
    
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
                    .foregroundColor(Color("text-textfield"))
                    .onReceive(Just(verificationCode)) { _ in
                        TextHelper.limitText(&verificationCode, 6)
                    }
                    .padding(.horizontal)
                
            }
            .padding(.top, 34)
            
            // Error Label
            Text("Invalid verification code")
                .foregroundColor(.red)
                .font(Font.smallText)
                .padding(.top, 20)
                .opacity(isErrorVisible ? 1 : 0)
            
            Spacer()
            
            Button {
                
                // Hide error message
                isErrorVisible = false
                
                // Disable button against multiple taps
                isButtonDisabled = true
                
                // Send the code to firebase
                AuthViewModel.verifyCode(code: verificationCode) { error in
                    
                    if error == nil {
                        
                        // check if this user has a profile
                        DatabaseService().checkUserProfile { exists in
                            
                            if exists {
                                // End the onboarding
                                isOnboarding = false
                                
                                // Load contacts
                                contactsViewModel.getLocalContacts()
                                
                                    // Load chats
                                chatViewModel.getChats()
                                
                            } else {
                                // Move to Profile Creation Step
                                currentStep = .profile
                            }
                                
                        }
                        
                        
                    } else {
                        // Show error message
                        isErrorVisible = true
                    }
                    
                    isButtonDisabled = false
                }
                
              
                
            } label: {
                
                HStack {

                    Text("Next")

                    if isButtonDisabled {
                        ProgressView()
                            .padding(.leading, 5)
                    }
                    
                }
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
            .disabled(isButtonDisabled)

            
        }
        .padding(.horizontal)

    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(true))
    }
}
