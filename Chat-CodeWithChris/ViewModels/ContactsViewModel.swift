//
//  ContactsViewModel.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 13/07/2022.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject {
    
    private var users = [User]()
    
    private var filterText = ""
    @Published var filteredUsers = [User]()
    
    private var localContacts = [CNContact]()
    
    func getLocalContacts() {
        
        // Perform this asynchronously so it doesn't block the UI
        DispatchQueue.init(label: "getContacts") .async {
            do {
                // Ask for permission
                let store = CNContactStore()
                
                // List of keys we want to collect
                let keys = [CNContactPhoneNumbersKey,
                            CNContactGivenNameKey,
                            CNContactFamilyNameKey] as! [CNKeyDescriptor]
                
                // Create a CN Fetch Request
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                
                // Get the contacts on the users phone
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, success in
                    
                    // Do something with the contact
                    self.localContacts.append(contact)
                    
                })
                
                // See which contacts are already on the app
                DatabaseService().getPlatformUsers(localContacts: self.localContacts) { platformUsers in
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        // Set the fetched users to the published users property
                        self.users = platformUsers
                        
                        // TODO: Set the filtered list
                        self.filterContacts(filterby: self.filterText)
                    }
                    
                }
                
            }
            catch {
                // Handle error
            }
        }
        
        
    }
    
    func filterContacts(filterby: String) {
        
        // Store parameter into property
        self.filterText = filterby
        
        // If filter text is empty then reveal all users
        if filterText == "" {
            self.filteredUsers = users
            return
        }
        
        // Run the users list through the filter term to get a list of filtered users
        self.filteredUsers = users.filter({ user in
            
            // Criteria for including this user into filtered users list
            user.firstname?.lowercased().contains(filterText) ?? false ||
            user.lastname?.lowercased().contains(filterText) ?? false ||
            user.phone?.lowercased().contains(filterText) ?? false
            
        })
    }
    
}
