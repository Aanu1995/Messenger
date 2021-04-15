//
//  ChatAppUser.swift
//  Messenger
//
//  Created by user on 11/04/2021.
//

import Foundation

struct ChatAppUser: Codable, Equatable {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let photoURL: String
}

// only required as addition
extension ChatAppUser {
    var fullName: String {
        return firstName.sentencecased() + " " + lastName.sentencecased()
    }
}



