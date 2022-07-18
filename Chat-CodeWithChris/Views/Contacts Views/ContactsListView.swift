//
//  ContactsListView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 18/07/2022.
//

import SwiftUI

struct ContactsListView: View {
    
    @EnvironmentObject private var contactsViewModel: ContactsViewModel
    
    @State private var filterText = ""
    
    var body: some View {

        VStack {

            // Heading
            HStack {
            
            Text("Contacts")
                .font(Font.pageTitle)
            
            Spacer()
            
            Button {
                // TODO: Settings Button
                
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("icons-secondary"))
            }

        }
            .padding(.top, 20)
            
            // Search Bar
            ZStack {
                
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(20)
                
                TextField("Search for contact or number", text: $filterText)
                    .font(Font.tabBar)
                    .foregroundColor(Color("text-textfield"))
                    .padding()
            }
            .frame(height: 46)
            
            if contactsViewModel.users.count > 0 {
                
                // List
                List(contactsViewModel.users) { user in
                    
                    // TODO: Display rows
                    Text(user.firstname ?? "Test User")
                }
                .listStyle(.plain)
            } else {
                VStack {
                    
                    Spacer()
                    
                    Image("no-contacts-yet")

                    Text("Hmm... No contacts")
                        .font(Font.titleText)
                        .padding(.top, 32)
                    
                    Text("Try saving some contacts from your phone!")
                        .font(Font.bodyParagraph)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                }
            }
            

        }
        .padding(.horizontal)
        .onAppear {
            // Get local contacts
            contactsViewModel.getLocalContacts()
        }
        
    }
}

struct ContactsListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsListView()
    }
}
