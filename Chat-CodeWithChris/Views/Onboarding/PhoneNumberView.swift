//
//  PhoneNumberView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import SwiftUI
import Combine

struct PhoneNumberView: View {
    
    @State private var phoneNumber = ""
    @Binding var currentStep: OnboardingStep
    @State private var isButtonDisabled = false
    @State private var isErrorVisible = false
    
    var body: some View {

        VStack {
            
            Text("Verification")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Enter your mobile number below. We'll send you a verification code after.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            // Textfield
            ZStack {
                
                Rectangle()
                    .frame(height: 56)
                    .foregroundColor(Color("input"))
                    .cornerRadius(5)
                
                HStack {
                    
                    TextField("e.g +1 123 123 1234", text: $phoneNumber)
                        .font(Font.bodyParagraph)
                        .keyboardType(.phonePad)
                        .foregroundColor(Color("text-textfield"))
                        .onReceive(Just(phoneNumber)) { _ in
                            TextHelper.applyPatternOnNumbers(&phoneNumber,
                                                             pattern: "+# (###) ###-####",
                                                             replacementCharacter: "#")
                        }
                        .placeholder(when: phoneNumber.isEmpty) {
                            Text("e.g +1 123 123 1234")
                                .font(Font.bodyParagraph)
                                .foregroundColor(Color("text-textfield"))
                        }
                    
                    Spacer()
                    
                    Button {
                        // Clear text field
                        phoneNumber = ""
                        
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                    }
                    .frame(width: 19, height: 19)
                    .tint(Color("icons-input"))

                }
                .padding()
                
            }
            .padding(.top, 34)
            
            
            // Error Label
            Text("Please enter a valid phone number")
                .foregroundColor(.red)
                .font(Font.smallText)
                .padding(.top, 20)
                .opacity(isErrorVisible ? 1 : 0)
            
            Spacer()
            
            Button {
                
                // hide the error label
                isErrorVisible = false
                
                // Disable button from multiple taps
                isButtonDisabled = true
                
                // Send their phone number to firebase
                AuthViewModel.sendPhoneNumber(phone: phoneNumber) { error in
                    // check for errors
                    if error == nil {
                        
                        // Move to next step
                        currentStep = .verification
                    } else {
                        // Show an error
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

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.phoneNumber))
    }
}
