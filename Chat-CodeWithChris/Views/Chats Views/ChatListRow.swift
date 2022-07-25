//
//  ChatListRow.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 25/07/2022.
//

import SwiftUI

struct ChatListRow: View {
    
    var chat: Chat
    
    var otherParticipants: [User]?
    
    var body: some View {

        HStack(spacing: 24) {
            
            // Assume at least 1 other participant in the chat
            let participant = otherParticipants?.first
            
            // Profile Image of participants
            if participant != nil {
                ProfilePicView(user: participant!)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Name
                Text(participant == nil ? " Unknown" :
                        "\(participant!.firstname ?? "") \(participant!.lastname ?? "")")
                    .font(Font.button)
                    .foregroundColor(Color("text-primary"))
                
                // Last message
                Text(chat.lastmsg ?? "")
                    .font(Font.bodyParagraph)
                    .foregroundColor(Color("text-input"))
            }
            
            Spacer()
            
            // Timestamp
            Text(chat.updated == nil ? "" : DateHelper.chatTimestampFrom(date: chat.updated!))
                .font(Font.bodyParagraph)
                .foregroundColor(Color("text-input"))
            
        }

    }
}

