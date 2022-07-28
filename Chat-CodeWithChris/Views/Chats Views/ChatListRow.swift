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
            
            if otherParticipants != nil && otherParticipants!.count == 1 {
                
                // Display profile pic of single participant
                if participant != nil {
                    ProfilePicView(user: participant!)
                }
            } else if otherParticipants != nil && otherParticipants!.count > 1 {
                
                // Display group profile pic
                GroupProfilePicView(users: otherParticipants!)
            }
            
           
            
            VStack(alignment: .leading, spacing: 4) {
                // Name
                
                if let otherParticipants = otherParticipants {
                    
                    Group {
                        
                    if otherParticipants.count == 1 {
                        
                        Text("\(participant!.firstname ?? "") \(participant!.lastname ?? "")")
                        
                    } else if otherParticipants.count == 2 {
                    
                        let participant2 = otherParticipants[1]
                        
                        Text("\(participant!.firstname ?? ""), \(participant2.firstname ?? "")")
                        
                    } else if otherParticipants.count > 2 {
                        let participant2 = otherParticipants[1]
                        
                        Text("\(participant!.firstname ?? ""), \(participant2.firstname ?? "") + \(otherParticipants.count - 2) others")
                            
                    }
                    
                }
                    .font(Font.button)
                    .foregroundColor(Color("text-primary"))
                    
                }
                
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

