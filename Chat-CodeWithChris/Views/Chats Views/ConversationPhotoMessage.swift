//
//  ConversationPhotoMessage.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 28/07/2022.
//

import SwiftUI

struct ConversationPhotoMessage: View {
  
    var imageurl: String
    var isFromUser: Bool
    var isActive: Bool = true
    
    var body: some View {

        // If user is inactive show this message
        if !isActive {
            ConversationTextMessage(message: "Photo Deleted",
                                    isFromUser: isFromUser,
                                    name: nil,
                                    isActive: isActive)
        }
        else if let cachedImage = CacheService.getImage(forKey: imageurl) {
            
            // Image is in the cache so we'll use that
            cachedImage
                .resizable()
                .scaledToFill()
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(isFromUser ? Color("bubble-primary") : Color("bubble-secondary"))
                .cornerRadius(30, corners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
            
        } else {
            // Download the image
            // Create url from message photo url
            let photoUrl = URL(string: imageurl)
        
            AsyncImage(url: photoUrl) { phase in
            
            switch phase {
            case .empty:
                // Currently Fetching
                ProgressView()
                
            case .success(let image):
                // Display the fetched image
               
                image
                    .resizable()
                    .scaledToFill()
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(isFromUser ? Color("bubble-primary") : Color("bubble-secondary"))
                    .cornerRadius(30, corners: isFromUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                    .onAppear {
                        // Save image to cache
                        CacheService.setImage(image: image, forKey: imageurl)
                    }
                
            case .failure:
                // Couldn't fetch profile photo
                ConversationTextMessage(message: "Couldn't load image", isFromUser: true)
                
                
            }
        }
        
        }

    }
}

struct ConversationPhotoMessage_Previews: PreviewProvider {
    static var previews: some View {
        ConversationPhotoMessage(imageurl: "", isFromUser: true)
    }
}
