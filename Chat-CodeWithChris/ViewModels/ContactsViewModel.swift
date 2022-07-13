//
//  ContactsViewModel.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 13/07/2022.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject {
    
    @Published var users = [User]()
    
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
                    }
                    
                }
                
            }
            catch {
                // Handle error
            }
        }
        
        
    }
    
}
