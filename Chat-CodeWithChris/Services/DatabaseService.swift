//
//  DatabaseService.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 13/07/2022.
//

import Foundation
import Contacts
import Firebase

class DatabaseService {
    
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping ([User]) -> Void ) {
        
        var platformUsers = [User]()
        
        // Construct an array of string phone numbers to look up
        
        var lookupPhoneNumbers = localContacts.map { contact in
            // Turn the contact into a phone number as a string
            return TextHelper.sanitizePhoneNumber(contact.phoneNumbers.first?.value.stringValue ?? "")
        }
        
        // Make sure there are lookup Numbers
        guard lookupPhoneNumbers.count > 0 else {
            completion(platformUsers)
            return
        }
        
        // Query the database from these phone numbers
        
        let db = Firestore.firestore()
        
        
        // Perform query while we still have numbers to lookup
        while !lookupPhoneNumbers.isEmpty {
        
            // Get the first < 10 phone numbers to look up as the query below has a max of 10 at a time
            let tenPhoneNumbers = Array(lookupPhoneNumbers.prefix(10))
            
            // Remove the 10 that we're looking up
            lookupPhoneNumbers = Array(lookupPhoneNumbers.dropFirst(10))
            
            let query = db.collection("users").whereField("phone", in: tenPhoneNumbers)
        
            // Retrieve the users that are on the platform
            query.getDocuments { snapshot, error in
                
                // check for errors
                if error == nil && snapshot != nil {
                    
                    // for each document that was fetched, create a user
                    for doc in snapshot!.documents {
                        
                        if let user = try? doc.data(as: User.self) {
                            
                            // Append to the platform users array
                            platformUsers.append(user)
                        }
                    }
                    
                    // Check if we have any more phone numbers to look up, if not we can call the completion block
                    if lookupPhoneNumbers.isEmpty {
                        // Return users
                        completion(platformUsers)
                    }
                    
                }
                
            }
            
        }
        
        
        
    }
    
}
