//
//  CustomTabBar.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 11/07/2022.
//

import SwiftUI

enum Tabs: Int {
    case chats = 0
    case contacts = 1
    
}

struct CustomTabBar: View {

    @EnvironmentObject var chatViewModel: ChatViewModel
    
    @Binding var selectedTab: Tabs
    @Binding var ischatShowing: Bool
    
    var body: some View {
        
        HStack {
            
            Button {
                // Switch to Chats
                selectedTab = .chats
                
            } label: {
                
                TabBarButton(buttonText: "Chats",
                             imageName: "bubble.left",
                             isActive: selectedTab == .chats)
            }
            .tint(Color("icons-secondary"))

            
            Button {
                // Open new chat
//                AuthViewModel.logOut()
                
                // Clear the selected chat
                chatViewModel.clearSelectedChat()
                
                ischatShowing = true
                
            } label: {
                
                VStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    
                    Text("New Chat")
                        .font(Font.tabBar)
                }
                
            }
            .tint(Color("icons-primary"))
            
            
            Button {
                // Switch to Contacts
                selectedTab = .contacts
                
            } label: {
                
                TabBarButton(buttonText: "Contacts", imageName: "person", isActive: selectedTab == .contacts)
                
            }
            .tint(Color("icons-secondary"))
            
        }
        .frame(height: 82)
        
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.contacts),ischatShowing: .constant(false))
    }
}
