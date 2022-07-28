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
    
    var body: some View {
        
        Text(message)
            .font(Font.bodyParagraph)
            .foregroundColor(isFromUser ? Color("text-button") : Color("text-primary"))
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
