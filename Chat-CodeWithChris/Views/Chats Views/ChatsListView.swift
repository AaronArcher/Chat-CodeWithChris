//
//  ChatsListView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 18/07/2022.
//

import SwiftUI

struct ChatsListView: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    @Binding var isChatShowing: Bool
    
    var body: some View {

        if chatViewModel.chats.count > 0 {
            
            // Show List
            List(chatViewModel.chats) { chat in
            
                Button {
                    // Set selected chat for ChatViewModel
                    chatViewModel.selectedChat = chat
                    
                    // Display conversation View
                    isChatShowing = true
                    
                } label: {
                    
                    Text(chat.id ?? "empty chat id")
                
                }
            
            }
            
        } else {
            Text("No Chats")
        }
        

    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView(isChatShowing: .constant(false))
    }
}
