//
//  AuthViewModel.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 12/07/2022.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    static func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func getLoggedInUserID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    static func logOut() {
        try? Auth.auth().signOut()
    }
    
    static func sendPhoneNumber(phone: String, completion: @escaping (Error?) -> Void) {
        
        // Send the phone number to Firebase Auth
        PhoneAuthProvider.provider().verifyPhoneNumber(phone,
                                                       uiDelegate: nil) { verificationID, error in
            
            if error == nil {
                // Got the verificationID
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion(error)

            }
            
            DispatchQueue.main.async {
                // Notify the UI
                completion(error)
            }
            
            
        }
        
    }
    
    static func verifyCode(code: String, completion: @escaping (Error?) -> Void) {
        // Get the verificationID from local storage
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        
        // Send the code and the verificationID to firebase
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        // Sign in the user
        Auth.auth().signIn(with: credential) { authResult, error in
            
            DispatchQueue.main.async {
                // Notify the UI
                completion(error)
            }
            
            
        }
    }
    
    
}
