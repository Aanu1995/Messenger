//
//  Sender.swift
//  Messenger
//
//  Created by user on 14/04/2021.
//

import Foundation
import MessageKit

struct Sender: SenderType, Equatable {
    var photoURL: String
    var senderId: String
    var displayName: String
}
