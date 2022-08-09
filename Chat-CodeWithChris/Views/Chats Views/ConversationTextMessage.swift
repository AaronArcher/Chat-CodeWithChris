//
//  ConversationViewTextMessage.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 28/07/2022.
//

import SwiftUI

struct ConversationTextMessage: View {
    
    var message: String
    var isFromUser: Bool
    var name: String?
    var isActive: Bool = true
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            // Name
            if let name = name {
                Text(name)
                    .font(Font.chatName)
                    .foregroundColor(Color("bubble-primary"))
            }
            
            // Text
            Text(isActive ? message : "Message Deleted")
                .font(Font.bodyParagraph)
                .foregroundColor(isFromUser ? Color("text-button") : Color("text-secondary"))
            
            
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(isFromUser ? Color("bubble-primary") : Color("bubble-secondary"))
        .cornerRadius(30, corners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
        
        
    }
}

struct ConversationViewTextMessage_Previews: PreviewProvider {
    static var previews: some View {
        ConversationTextMessage(message: "test", isFromUser: true)
    }
}
