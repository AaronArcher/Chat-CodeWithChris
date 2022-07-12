//
//  ContentView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 11/07/2022.
//

import SwiftUI

struct RootView: View {
    
    @State private var selectedTab: Tabs = .contacts
    
    @State private var isOnboarding = !AuthViewModel.isUserLoggedIn()
    
    var body: some View {
        VStack {
            
            Text("Hello, world!")
                .padding()
            
            Spacer()
            
            CustomTabBar(selectedTab: $selectedTab)
            
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            // On dismiss
            
        } content: {
            // The onboarding sequence
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }

        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
