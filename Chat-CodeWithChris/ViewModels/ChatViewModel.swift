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
    
    func getChats() {
        // User the database service to retrieve the chats
        databaseService.getAllChats { chats in
            
            // Set the retrieved data to the chats property
            self.chats = chats
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
    
    func sendMessage(msg: String) {
        
        // Check that we have a selected chat
        guard selectedChat != nil else { return }
        
        databaseService.sendMessage(msg: msg, chat: selectedChat!)
        
    }
    
}
