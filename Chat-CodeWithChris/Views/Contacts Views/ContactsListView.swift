//
//  ContactsListView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 18/07/2022.
//

import SwiftUI

struct ContactsListView: View {
    
    @EnvironmentObject private var contactsViewModel: ContactsViewModel
    @EnvironmentObject private var chatViewModel: ChatViewModel
    
    @State private var filterText = ""
    
    @Binding var isChatShowing: Bool
    
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
            .onChange(of: filterText) { _ in
                // Filter the results
                contactsViewModel.filterContacts(filterby: filterText
                    .lowercased()
                    .trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            if contactsViewModel.filteredUsers.count > 0 {
                
                // List
                List(contactsViewModel.filteredUsers) { user in
                    
                    Button {
                        
                        // Search for an existing convo with this user
                        chatViewModel.getChatFor(contacts: [user])
                        
                        // Display conversation view
                        isChatShowing = true
                        
                    } label: {
                        //  Display rows
                        ContactRow(user: user)
                            
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .padding(.top, 12)
                
            } else {
                    
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
        .padding(.horizontal)
        
        
    }
}

struct ContactsListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsListView(isChatShowing: .constant(false))
    }
}
