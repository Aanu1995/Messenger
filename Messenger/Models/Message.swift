//
//  Message.swift
//  Messenger
//
//  Created by user on 14/04/2021.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
