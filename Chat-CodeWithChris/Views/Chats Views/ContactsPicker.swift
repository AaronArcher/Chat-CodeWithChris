//
//  ContactsPicker.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 28/07/2022.
//

import SwiftUI

struct ContactsPicker: View {
    
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @Binding var isContactsPickerShowing: Bool
    @Binding var selectedContacts: [User]
    
    var body: some View {

        VStack(spacing: 0) {
            
            ScrollView {
                
                ForEach(contactsViewModel.filteredUsers) { user in
                    
                    // Determine if this user is a selected Contact
                    let isSelectedContact = selectedContacts.contains { u in
                        u.id == user.id
                    }
                    
                    ZStack {
                    
                        ContactRow(user: user)
                                                
                        HStack {
                            Spacer()
                            
                            Button {
                                // Toggle the user selected or not
                                if isSelectedContact {
                                    // Remove this contact from selected contacts
                                    selectedContacts.removeAll()
                                    
                                } else {
                                    // Remove other contacts first
                                    selectedContacts.removeAll()
                                    
                                    // Add this user
                                    selectedContacts.append(user)
                                }
                                
                            } label: {
                                Image(systemName: isSelectedContact ? "checkmark.circle.fill" : "checkmark.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("button-primary"))
                            }

                        }
                        .padding(.trailing)
                        
                    }
                }
                
            }
            .padding(.top, 15)
            .padding(.horizontal)

            
            // Done button
            Button {
                // Dismiss the contacts picker
                isContactsPickerShowing = false
                
            } label: {
                
                ZStack {
                    Color("button-primary")
                    
                    Text("Done")
                        .font(Font.button)
                        .foregroundColor(Color("text-button"))
                }
                .frame(height: 56)
                
            }

            
        }
        .background(Color("background").ignoresSafeArea())
        .onAppear {
            // Clear any filters on the contact
            contactsViewModel.filterContacts(filterby: "")
        }

    }
}

