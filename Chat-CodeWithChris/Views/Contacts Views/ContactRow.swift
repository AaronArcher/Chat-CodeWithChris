//
//  ContactRow.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 18/07/2022.
//

import SwiftUI

struct ContactRow: View {
    
    var user: User
    
    var body: some View {
        
        HStack(spacing: 24) {
            
            // Profile Image
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
                    
                } else {
                 
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
                            
                        }
                    }
                    
                }
                
                Circle()
                    .stroke(Color("create-profile-border"), lineWidth: 2)
                
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                // Name
                Text("\(user.firstname ?? "") \(user.lastname ?? "")")
                    .font(Font.button)
                    .foregroundColor(Color("text-primary"))
                
                // Phone number
                Text(user.phone ?? "")
                    .font(Font.bodyParagraph)
                    .foregroundColor(Color("text-input"))
            }
            
            Spacer()
            
        }
        
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(user: User())
    }
}
