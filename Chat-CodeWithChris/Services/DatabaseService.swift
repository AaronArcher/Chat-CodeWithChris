//
//  DatabaseService.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 13/07/2022.
//

import Foundation
import Contacts
import Firebase
import FirebaseStorage
import UIKit

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
    
    func setUserProfile(firstname: String, lastname: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
        // TODO: Guard against logged in users
        
        // Get a reference to Firestore
        let db = Firestore.firestore()
        
        // Set profile data
        // TODO: After implementing authentication, instead create a document with the actual users uid
        let doc = db.collection("users").document()
        doc.setData(["firstname": firstname,
                     "lastname": lastname])
        
        // Check if image is passed through
        if let image = image {
            
            // Create storage reference
                    let storageRef = Storage.storage().reference()
                    
                    // Turn our image into data
                    let imageData = image.jpegData(compressionQuality: 0.8)
                    
                    // Check that we were able to convert it to data
                    guard imageData != nil else {
                        return
                    }
                    
                    // Specify the file path and name
                    let path = "images/\(UUID().uuidString).jpg"
                    let fileRef = storageRef.child(path)
        
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { meta, error in
                
                if error == nil && meta != nil {
                    // Set image path to the profile
                    doc.setData(["photo": path], merge: true) { error in
                        
                        if error == nil {
                            // Success, notify caller
                            completion(true)
                        }
                    }
                    
                } else {
                    // Upload wasn't successful, notify caller
                    completion(false)
                }
                
            }


        }
                        
    }
    
}
