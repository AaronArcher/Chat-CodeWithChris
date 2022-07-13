//
//  User.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 13/07/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    
    @DocumentID var id: String?
    var firstname: String?
    var lastname: String?
    var phone: String?
    var photo: String?
    
}
