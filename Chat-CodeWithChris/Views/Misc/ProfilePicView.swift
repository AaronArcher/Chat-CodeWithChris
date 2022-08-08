//
//  ProfilePicView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 19/07/2022.
//

import SwiftUI

struct ProfilePicView: View {
    
    var user: User
    
    var body: some View {

        ZStack {
            
            // Check if user has a photo set
            if user.photo == nil {
                
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                    
                    Text(user.firstname?.prefix(1) ?? "")
                        .font(Font.button)
                    +
                    Text(user.lastname?.prefix(1) ?? "")
                        .font(Font.button)
                    
                }
                .foregroundColor(Color("text-secondary"))

                
            } else {
                
                // Check image cache, if it exists, use that
                if let cachedImage = CacheService.getImage(forKey: user.photo!) {
                    
                    // Image is in the cache so we'll use that
                    cachedImage
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFill()
                        .clipped()
                    
                } else {
                    
                    // If not in cache, download it
                    
                    // Create url from user photo url
                    let photoUrl = URL(string: user.photo ?? "")
                    
                    AsyncImage(url: photoUrl) { phase in
                        
                        switch phase {
                        case .empty:
                            // Currently Fetching
                            ProgressView()
                            
                        case .success(let image):
                            // Display the fetched image
                            image
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFill()
                                .clipped()
                                .onAppear {
                                    // Save this image into cache
                                    CacheService.setImage(image: image,
                                                          forKey: user.photo!)
                                }
                            
                        case .failure:
                            // Couldn't fetch profile photo
                            
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                
                                Text(user.firstname?.prefix(1) ?? "")
                                    .font(Font.button)
                                +
                                Text(user.lastname?.prefix(1) ?? "")
                                    .font(Font.button)
                                
                            }
                            .foregroundColor(Color("text-secondary"))

                            
                        }
                    }
                    
                }
                
                
            }
            
            Circle()
                .stroke(Color("create-profile-border"), lineWidth: 2)
            
        }
        .frame(width: 44, height: 44)

    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(user: User())
    }
}
