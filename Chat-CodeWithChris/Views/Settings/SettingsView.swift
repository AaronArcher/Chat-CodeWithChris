//
//  SettingsView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 08/08/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isSettingsShowing: Bool
    @Binding var isOnboarding: Bool
    
    @State private var isDarkMode = false
    
    var body: some View {

        VStack {
            
            // Header
            HStack {
                
                Text("Settings")
                    .font(Font.pageTitle)
                
                Spacer()
                
                Button {
                    // Close Settings
                    isSettingsShowing = false
                    
                } label: {
                    Image(systemName: "multiply")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("icons-secondary"))
                }
                
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            // Form
            Form {
                
                Toggle("Dark Mode", isOn: $isDarkMode)
                
                Button {
                    //  Log out
                    AuthViewModel.logOut()
                    
                    // Show login screen again
                    isOnboarding = true
                
                } label: {
                    Text("Log Out")
                }
                
                Button {
                    // TODO: Delete Account
                    
                } label: {
                    Text("Delete Account")
                }

                
            }
            
        }
        .background(Color("background").ignoresSafeArea())


    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isSettingsShowing: .constant(true), isOnboarding: .constant(false))
    }
}
