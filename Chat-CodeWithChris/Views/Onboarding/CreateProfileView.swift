//
//  CreateProfileView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import SwiftUI

struct CreateProfileView: View {
    
    @Binding var currentStep: OnboardingStep
    
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {

        VStack {
            
            Text("Setup your Profile")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Just a few more details to get started.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            Spacer()
            
            // Profile image button
            Button {
                // Show action sheet
                
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                    
                    Circle()
                        .stroke(Color("create-profile-border"), lineWidth: 2)
                    
                    Image(systemName: "camera.fill")
                        .tint(Color("icons-input"))
                    
                }
                .frame(width: 134, height: 134)
            }

            Spacer()
            
            // First name
            TextField("First Name", text: $firstName)
                .textFieldStyle(CreateProfileTextfieldStyle())
            
            // Last name
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CreateProfileTextfieldStyle())
            
            Spacer()
            
            Button {
                // Next Step
                currentStep = .contacts
                
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)

            
        }
        .padding(.horizontal)

    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
