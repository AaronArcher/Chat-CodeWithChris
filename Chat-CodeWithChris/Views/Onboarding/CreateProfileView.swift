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
    
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    @State private var isSourceMenuShowing = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isSaveButtonDisabled = false
    
    @State private var isErrorVisible = false
    @State private var errorMessage = ""
    
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
                isSourceMenuShowing = true
                
            } label: {
                
                ZStack {
                    
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                        
                    } else {
                        
                        Circle()
                            .foregroundColor(.white)
                        
                        Image(systemName: "camera.fill")
                            .tint(Color("icons-input"))
                        
                    }
                    
                    Circle()
                        .stroke(Color("create-profile-border"), lineWidth: 2)
                    
                }
                .frame(width: 134, height: 134)
            }
            
            Spacer()
            
            // First name
            TextField("First Name", text: $firstName)
                .textFieldStyle(CreateProfileTextfieldStyle())
                .placeholder(when: firstName.isEmpty) {
                    Text("First Name")
                        .font(Font.bodyParagraph)
                        .foregroundColor(Color("text-textfield"))
                }
            
            // Last name
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CreateProfileTextfieldStyle())
                .placeholder(when: lastName.isEmpty) {
                    Text("Last Name")
                        .font(Font.bodyParagraph)
                        .foregroundColor(Color("text-textfield"))
                }
            
            // Error Label
            Text(errorMessage)
                .foregroundColor(.red)
                .font(Font.smallText)
                .padding(.top, 20)
                .opacity(isErrorVisible ? 1 : 0)
            
            Spacer()
            
            Button {
                
                // Hide error message
                isErrorVisible = false
                
                
                // Check that the first and last name are filled in before allowing the profile to be created
                guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    
                    errorMessage = "Please enter in a valid first and last name"
                    isErrorVisible = true
                    return
                }

                // Prevent double taps
                isSaveButtonDisabled = true
                
                // Save the data
                DatabaseService().setUserProfile(firstname: firstName,
                                                 lastname: lastName,
                                                 image: selectedImage) { isSuccess in
                    
                    if isSuccess {
                        currentStep = .contacts

                    } else {
                        // Show error message to user
                        errorMessage = "Error Occured, please try again."
                        isErrorVisible = true
                    }

                    isSaveButtonDisabled = false

                }
                
                
                
            } label: {
                Text(isSaveButtonDisabled ? "Uploading" : "Save")
            }
            .buttonStyle(OnboardingButtonStyle())
            .disabled(isSaveButtonDisabled)
            .padding(.bottom, 87)
            
            
        }
        .padding(.horizontal)
        .confirmationDialog("From where?", isPresented: $isSourceMenuShowing, actions: {
            
            Button {
                // Set the source to photo library and show image picker
                source = .photoLibrary
                isPickerShowing = true
                
            } label: {
                Text("Photo Library")
            }

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
             
                Button {
                    // Set the source to camera and show image picker
                    source = .camera
                    isPickerShowing = true
                    
                } label: {
                    Text("Take Photo")
                }
                
            }

            
        })
        .sheet(isPresented: $isPickerShowing) {
            // Show the image picker
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: source)
        }
        
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
