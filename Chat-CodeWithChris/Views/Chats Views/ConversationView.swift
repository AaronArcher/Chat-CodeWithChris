//
//  ConversationView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 19/07/2022.
//

import SwiftUI

struct ConversationView: View {
    
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @EnvironmentObject private var contactsViewModel: ContactsViewModel
    
    @Binding var isChatShowing: Bool
    
    @State private var chatMessage = ""
    
    @State private var participants = [User]()
    
    @State private var selectedImage: UIImage?
    @State private var isPickerShowing = false
    @State private var isSourceMenuShowing = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        
        VStack(spacing: 0) {
            
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
                    if participants.count > 0 {
                        let participant = participants.first
                        Text("\(participant?.firstname ?? "") \(participant?.lastname ?? "")")
                            .font(Font.chatHeading)
                            .foregroundColor(Color("text-header"))
                    }
                    
                }
                
                Spacer()
                
                // Profile Image
                if participants.count > 0 {
                    
                    let participant = participants.first
                    
                    ProfilePicView(user: participant!)
                    
                }
                
            }
            .frame(height: 104)
            .padding(.horizontal)
            
            
            // Chat Log
            
            ScrollViewReader { proxy in
                
                ScrollView {
                    
                    VStack(spacing: 24) {
                        
                        ForEach(Array(chatViewModel.messages.enumerated()), id: \.element) { index, message in
                            
                            let isFromUser = message.senderid == AuthViewModel.getLoggedInUserID()
                            
                            // Dynamic Messages
                            HStack {
                                
                                if isFromUser {
                                    
                                    // Timestamp
                                    Text(DateHelper.chatTimestampFrom(date: message.timestamp))
                                        .font(Font.smallText)
                                        .foregroundColor(Color("text-timestamp"))
                                        .padding(.trailing)
                                    
                                    Spacer()
                                    
                                }
                                
                                
                                if message.imageurl != "" {
                                    // Photo message
                                    
                                    // Check image cache, if it exists, use that
                                    ConversationPhotoMessage(imageurl: message.imageurl!, isFromUser: isFromUser)
                                    
                                } else {
                                    // Text message
                                    ConversationTextMessage(message: message.msg, isFromUser: isFromUser)
                                    
                                }
                                
                                if !isFromUser {
                                    
                                    Spacer()
                                    
                                    // Timestamp
                                    Text(DateHelper.chatTimestampFrom(date: message.timestamp))
                                        .font(Font.smallText)
                                        .foregroundColor(Color("text-timestamp"))
                                        .padding(.leading)
                                    
                                }
                                
                            }
                            .id(index)
                            
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    
                }
                .background(Color("background").ignoresSafeArea())
                .onChange(of: chatViewModel.messages.count) { newCount in
                    withAnimation {
                        proxy.scrollTo(newCount - 1)
                    }
                }
                
                
            }
            
            // Chat Message bar
            HStack(spacing: 15) {
                // Camera Button
                Button {
                    // Show Picker
                isSourceMenuShowing = true
                    
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
                    
                    if selectedImage != nil {
                        // display image in message bar
                        Text("Image")
                            .foregroundColor(Color("text-input"))
                            .font(Font.bodyParagraph)
                            .padding(10)
                        
                        // Delete Button
                        HStack {
                            Spacer()
                            
                            Button {
                                selectedImage = nil
                                
                            } label: {
                                
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("text-input"))
                                
                            }
                        }
                        .padding(.trailing, 12)

                        
                    } else {
                        
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
                    
                    
                    
                }
                .frame(height: 44)
                
                
                // Send Button
                Button {
                    
                    // Check if image is selected, if so, send image
                    if selectedImage != nil {
                        // Send image message
                        chatViewModel.sendPhotoMessage(image: selectedImage!)
                        
                        // Clear image
                        selectedImage = nil
                        
                    } else {
                        // Send text message
                     
                        // Clear up message
                        chatMessage = chatMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // Send Button
                        chatViewModel.sendMessage(msg: chatMessage)
                        
                        // Clear textbox
                        chatMessage = ""
                    }
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .tint(Color("icons-primary"))
                }
                .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines) == "" && selectedImage == nil)
                
                
            }
            .padding(.horizontal)
            .frame(height: 76)
            .background(Color("background").ignoresSafeArea())
            
            
        }
        .onAppear {
            // Call chat view model to retrieve all messages
            chatViewModel.getMessages()
            
            // Try to get the other participants as user instances
            let ids = chatViewModel.getParticipantIds()
            self.participants = contactsViewModel.getParticipants(ids: ids)
        }
        .onDisappear {
            // Do any necessary cleanup before conversation view disappears
            chatViewModel.conversationViewCleanup()
        }
        .confirmationDialog("From where?", isPresented: $isSourceMenuShowing, actions: {
            
            Button {
                // Set the source to photo library and show image picker
                source = .photoLibrary
                isPickerShowing = true
                
            } label: {
                Text("Photo Library")
            }

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
             
                Button {
                    // Set the source to camera and show image picker
                    source = .camera
                    isPickerShowing = true
                    
                } label: {
                    Text("Take Photo")
                }
                
            }

            
        })
        .sheet(isPresented: $isPickerShowing) {
            // Show the image picker
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: source)
        }

        
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(isChatShowing: .constant(false))
    }
}
