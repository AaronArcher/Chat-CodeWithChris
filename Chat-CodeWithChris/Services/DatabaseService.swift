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
    
    var chatListViewListeners = [ListenerRegistration]()
    var conversationViewListener = [ListenerRegistration]()
    
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
        
        // Ensure user is logged in
        guard AuthViewModel.isUserLoggedIn() != false else {
            // User is not logged in
            return
        }
        
        // Get user phone number
        let userPhone = TextHelper.sanitizePhoneNumber(AuthViewModel.getLoggedInUserPhone())
        
        // Get a reference to Firestore
        let db = Firestore.firestore()
        
        // Set profile data
        let doc = db.collection("users").document(AuthViewModel.getLoggedInUserID())
        doc.setData(["firstname": firstname,
                     "lastname": lastname,
                     "phone": userPhone])
        
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
                    
                    // Get full URL to image
                    fileRef.downloadURL { url, error in
                        
                        // Check for errors
                        if url != nil && error == nil {
                          
                            // Set image path to the profile
                            doc.setData(["photo": url!.absoluteString], merge: true) { error in
                                
                                if error == nil {
                                    // Success, notify caller
                                    completion(true)
                                }
                            }
                            
                        } else {
                            // Wasn't successful grabbing the url
                            completion(false)
                        }
                        
                    }
                    
                    
                    
                } else {
                    // Upload wasn't successful, notify caller
                    completion(false)
                }
                
            }


        }
        else {
            // No image was set
            completion(true)
        }
                        
    }

    func checkUserProfile(completion: @escaping (Bool) -> Void) {
        
        // Check that user is logged in
        guard AuthViewModel.isUserLoggedIn() != false else { return }
        
        // Create Firebase Reference
        let db = Firestore.firestore()
        
        db.collection("users").document(AuthViewModel.getLoggedInUserID()).getDocument { snapshot, error in
            
            // TODO: Keep the users profile data
            
            if snapshot != nil && error == nil {
                // Notify that profile exists
                completion(snapshot!.exists)
            }
            else {
                // TODO: Look into using Result type to indicate failure vs profile exists

                completion(false)
            }
            
        }
        
    }
    
    // MARK: - Chat Methods
    
    /// This method returns all chat documents where the logged in user is a participant
    func getAllChats(completion: @escaping ([Chat]) -> Void ) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Perform a query against the chat collection for any chats where the user is a particiipant
        let chatsQuery = db.collection("chats")
            .whereField("participantids", arrayContains: AuthViewModel.getLoggedInUserID())
        
        let listener = chatsQuery.addSnapshotListener { snapshot, error in
            if snapshot != nil && error == nil {
               
                var chats = [Chat]()
                
                // Loop through chat docs
                for doc in snapshot!.documents {
                
                    // Parse the data into Chat structs
                    let chat = try? doc.data(as: Chat.self)
                    
                    // Add the chats into the array
                    if let chat = chat {
                        chats.append(chat)
                    }
                }
                
                // Return the data
                completion(chats)
                
            } else {
                // There was an error
                print("error in database retrieval")
            }
        }
        
        // Keep track of the listener so we can close it later
        chatListViewListeners.append(listener)
    }
    
    
    /// This method returns all messages for a given chat
    func getAllMessages(chat: Chat, completion: @escaping ([ChatMessage]) -> Void ) {
        
        // Check that the id is not nil
        guard chat.id != nil else {
            // Can't fetch data
            completion([ChatMessage]())
            return
        }
        
        // Get a reference to the database
        let db = Firestore.firestore()

        // Create the query
        let msgsQuery = db.collection("chats")
            .document(chat.id!).collection("msgs")
            .order(by: "timestamp")
        
        // Perform the query
        let listener = msgsQuery.addSnapshotListener { snapshot, error in
            
            if snapshot != nil && error == nil {
                
                // Loop through message documents and create ChatMessage instances
                var messages = [ChatMessage]()
                
                for doc in snapshot!.documents {
                    
                    let msg = try? doc.data(as: ChatMessage.self)
                    
                    if let msg = msg {
                        messages.append(msg)
                    }
                }
                
                // Return the results
                completion(messages)
                
            } else {
                
                // There was an error
                print("error in database retrieval")
                
            }
            
        }
        
        // Keep track of listener so we can close it late
        conversationViewListener.append(listener)
        
    }
    
    /// Send a text message to the database
    func sendMessage(msg: String, chat: Chat) {
        
        // Check that it's a valid chat
        guard chat.id != nil else { return }
        
        // Get a reference to database
        let db = Firestore.firestore()
        
        // Add message document
        db.collection("chats")
            .document(chat.id!)
            .collection("msgs")
            .addDocument(data: ["imageurl" : "",
                                "msg" : msg,
                                "senderid" : AuthViewModel.getLoggedInUserID(),
                                "timestamp" : Date()])
        
        // Update chat document to reflect message that was just sent
        db.collection("chats")
            .document(chat.id!)
            .setData(["updated" : Date(),
                      "lastmsg" : msg], merge: true)
        
    }
    
    /// Send a photo message to the database
    func sendPhotoMessage(image: UIImage, chat: Chat) {
        
        // Check that it's a valid chat
        guard chat.id != nil else { return }
        
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
        
        // Upload the image
        fileRef.putData(imageData!, metadata: nil) { meta, error in
            
            // check for errors
            if error == nil && meta != nil {
            
                // get the url for image in storage
                fileRef.downloadURL { url, error in
                    
                    if url != nil && error == nil {
                        
                        // Store a chat message
                        let db = Firestore.firestore()
                        
                        // Add message document
                        db.collection("chats")
                            .document(chat.id!)
                            .collection("msgs")
                            .addDocument(data: ["imageurl" : url!.absoluteString,
                                                "msg" : "",
                                                "senderid" : AuthViewModel.getLoggedInUserID(),
                                                "timestamp" : Date()])
                        
                        // Update chat document to reflect message that was just sent
                        db.collection("chats")
                            .document(chat.id!)
                            .setData(["updated" : Date(),
                                      "lastmsg" : "Image"], merge: true)
                        
                    }
                }
                
            }
            
            
        }
        
    }
    
    
    func createChat(chat: Chat, completion: @escaping (String) -> Void) {
        
        // Get reference to database
        let db = Firestore.firestore()
        
        // Create a document
        let doc = db.collection("chats").document()
            
        // Set the data for the documents
        try? doc.setData(from: chat, completion: { error in
            
            // Communicate the document id
            completion(doc.documentID)
            
        })
        
    }
    
    func detachChatListViewListeners() {
        for listener in chatListViewListeners {
            listener.remove()
        }
    }
    
    func detachConversationViewListener() {
        for listener in conversationViewListener {
            listener.remove()
        }
    }
    
}
