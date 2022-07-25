//
//  ChatsListView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 18/07/2022.
//

import SwiftUI

struct ChatsListView: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @Binding var isChatShowing: Bool
    
    var body: some View {
        
        
        VStack {
            
            // Heading
            HStack {
                
                Text("Chats")
                    .font(Font.pageTitle)
                
                Spacer()
                
                Button {
                    // TODO: Settings Button
                    
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("icons-secondary"))
                }
                
            }
            .padding(.top, 20)
            .padding(.horizontal)

            
            // Chat List
         
            if chatViewModel.chats.count > 0 {
                
                // Show List
                List(chatViewModel.chats) { chat in
                    
                    Button {
                        // Set selected chat for ChatViewModel
                        chatViewModel.selectedChat = chat
                        
                        // Display conversation View
                        isChatShowing = true
                        
                    } label: {
                        
                        ChatListRow(chat: chat,
                                    otherParticipants: contactsViewModel.getParticipants(ids: chat.participantids))
                        
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                
            } else {

                Spacer()
                
                Image("no-chats-yet")

                Text("Hmm... No chats created yet!")
                    .font(Font.titleText)
                    .padding(.top, 32)
                
                Text("Start a chat with a friend")
                    .font(Font.bodyParagraph)
                    .padding(.top, 8)
                
                Spacer()

            }
            
        }
        
        
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView(isChatShowing: .constant(false))
    }
}
