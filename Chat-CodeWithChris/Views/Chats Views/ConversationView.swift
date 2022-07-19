//
//  ConversationView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 19/07/2022.
//

import SwiftUI

struct ConversationView: View {
    
    @Binding var isChatShowing: Bool
    
    @State private var chatMessage = ""
    
    var body: some View {

        VStack {
            
            // Chat Header
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Back Arrow
                    Button {
                        // Dismiss conversation window
                        isChatShowing = false
                        
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            .foregroundColor(Color("text-header"))
                    }
                        
                    
                    // Name
                    Text("Aaron Johncock")
                        .font(Font.chatHeading)
                        .foregroundColor(Color("text-header"))
                    
                }
                
                Spacer()
                
                // Profile Image
                ProfilePicView(user: User())
            }
            .frame(height: 104)
            .padding(.horizontal)

            
            // Chat Log
            ScrollView {
                
                VStack(spacing: 24) {
                    
                    // Their Message
                    HStack {
                        
                        // Message
                        Text("This is some dummy text to test...")
                            .font(Font.bodyParagraph)
                            .foregroundColor(Color("text-primary"))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(
                                Color("bubble-secondary")
                                    .cornerRadius(30, corners: [.topLeft, .topRight, .bottomRight])
                            )
                        
                        Spacer()
                        
                        // Timestamp
                        Text("9:41")
                            .font(Font.smallText)
                            .foregroundColor(Color("text-timestamp"))
                            .padding(.leading)
                        
                    }
                    
                    // Your Message
                    HStack {
                        
                        // Timestamp
                        Text("9:41")
                            .font(Font.smallText)
                            .foregroundColor(Color("text-timestamp"))
                            .padding(.trailing)
                        
                        Spacer()
                        
                        // Message
                        Text("This is some dummy text to test... This is some dummy text to test... This is some dummy text to test...")
                            .font(Font.bodyParagraph)
                            .foregroundColor(Color("text-button"))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(
                                Color("bubble-primary")
                                    .cornerRadius(30, corners: [.topLeft, .topRight, .bottomLeft])
                            )
                        
                        
                    }

                    
                }
                .padding(.horizontal)
                .padding(.top, 24)
                
            }
            .background(Color("background").ignoresSafeArea())
            
            // Chat Message bar
            HStack {
                // Camera Button
                Button {
                    // TODO: Show Picker
                    
                } label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color("icons-secondary"))
                }

                
                // Text Field
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(Color("date-pill"))
                        .cornerRadius(50)
                    
                    TextField("Type your message...", text: $chatMessage)
                        .foregroundColor(Color("text-input"))
                        .font(Font.bodyParagraph)
                        .padding(10)
                    
                    HStack {
                        Spacer()
                     
                        Button {
                            // Emojis
                            
                        } label: {
                            
                            Image(systemName: "face.smiling")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("text-input"))
                            
                        }
                    }
                    .padding(.trailing, 12)

                    
                    
                }
                .frame(height: 44)
            
                
                // Send Button
                Button {
                    // TODO: Send Button
                    
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .tint(Color("icons-primary"))
                }

                
            }
            .padding(.horizontal)
            .frame(height: 76)
            .background(Color("background").ignoresSafeArea())

            
        }

    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(isChatShowing: .constant(false))
    }
}
