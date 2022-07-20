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
    
    @State private var isChatShowing = false
    
    var body: some View {
        
        VStack {
            
            switch selectedTab {
            case .chats:
                ChatsListView(isChatShowing: $isChatShowing)
            case .contacts:
                ContactsListView(isChatShowing: $isChatShowing)
            }
            
            Spacer()
            
            CustomTabBar(selectedTab: $selectedTab)
            
        }
        .background(Color("background").ignoresSafeArea())
        .fullScreenCover(isPresented: $isOnboarding) {
            // On dismiss
            
        } content: {
            // The onboarding sequence
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
        .fullScreenCover(isPresented: $isChatShowing, onDismiss: nil) {
           
            // Show Conversation View
            ConversationView(isChatShowing: $isChatShowing)
        }
        
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
