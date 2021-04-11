//
//  ChatAppUser.swift
//  Messenger
//
//  Created by user on 11/04/2021.
//

import Foundation

struct ChatAppUser: Codable {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let photoURL: String
}
