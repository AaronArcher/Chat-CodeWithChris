//
//  ChatViewModel.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 19/07/2022.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var chats = [Chat]()
    
    @Published var selectedChat: Chat?
    
    @Published var messages = [ChatMessage]()
    
    var databaseService = DatabaseService()
    
    init() {
        // Retrieve chats when view model is created
        getChats()
    }
    
    func clearSelectedChat() {
        self.selectedChat = nil
        self.messages.removeAll()
    }
    
    func getChats() {
        // User the database service to retrieve the chats
        databaseService.getAllChats { chats in
            
            // Set the retrieved data to the chats property
            self.chats = chats
        }
        
        
        
    }
    
    /// Search for chat with passed in user, if found - set as selected chat. If not found, create a new chat
    func getChatFor(contact: User) {
        
        // Check the user
        guard contact.id != nil else { return }
        
        let foundChat = chats.filter { chat in
            
            return chat.numparticipants == 2 && chat.participantids.contains(contact.id!)
                
        }
        
        // Found a chat between the user and the contact
        if !foundChat.isEmpty {
            
            // Set as selected Chat
            self.selectedChat = foundChat.first!
            
            // Fetch the messages
            getMessages()
        
        } else {
            // No chat was found, create a new one
            let newChat = Chat(id: nil,
                               numparticipants: 2,
                               participantids: [AuthViewModel.getLoggedInUserID(), contact.id!],
                               lastmsg: nil,
                               updated: nil,
                               msgs: nil)
            
            // Set as selectedChat
            self.selectedChat = newChat
            
            // Save new chat to the database
            databaseService.createChat(chat: newChat) { docID in
                
                // Set doc ID from the auto generated one in the database
                self.selectedChat = Chat(id: docID,
                                         numparticipants: 2,
                                         participantids: [AuthViewModel.getLoggedInUserID(), contact.id!],
                                         lastmsg: nil,
                                         updated: nil,
                                         msgs: nil)
                
                // Add chat to the chat list
                self.chats.append(self.selectedChat!)
            }
            
        
        }
        
    }
    
    func getMessages() {
        
        // Check that there's a selected chat
        guard selectedChat != nil else { return }
        
        databaseService.getAllMessages(chat: selectedChat!) { messages in
            
            // Set returned messages to property
            self.messages = messages
            
        }
        
    }
    
    /// Send message to the database
    func sendMessage(msg: String) {
        
        // Check that we have a selected chat
        guard selectedChat != nil else { return }
        
        databaseService.sendMessage(msg: msg, chat: selectedChat!)
        
    }
    
    func sendPhotoMessage(image: UIImage) {
        
        // Check we have a chat selected
        guard selectedChat != nil else { return }
        
        databaseService.sendPhotoMessage(image: image, chat: selectedChat!)
        
    }
    
    func conversationViewCleanup() {
        databaseService.detachConversationViewListener()
    }
    
    func chatListViewCleanup() {
        databaseService.detachChatListViewListeners()
    }
    
    // MARK: Helper Methods
    
    /// Takes in a list of user ids, removes the user from that list and return the remaining ids
    func getParticipantIds() -> [String] {
        
        // check that we have a selected chat
        guard selectedChat != nil else { return [String]() }
        
        // Filter out the users id
        let ids = selectedChat!.participantids.filter { id in
            // Only keep user ids if it's not the users id
            id != AuthViewModel.getLoggedInUserID()
                    
        }
        return ids

        
    }
    
    
    
}
