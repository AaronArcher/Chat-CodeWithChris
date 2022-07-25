//
//  ContentView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 11/07/2022.
//

import SwiftUI

struct RootView: View {
    
    // For detecting with the app state changes
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
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
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .active {
                print("Active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
                chatViewModel.chatListViewCleanup()
            }
            
        }
        
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
