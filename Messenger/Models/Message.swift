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

extension MessageKind{
    var rawValue: String {
        switch self {
        
        case .text:
            return "text"
        case .attributedText:
            return "attributedText"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .location:
            return "location"
        case .emoji:
            return "emoji"
        case .audio:
            return "audio"
        case .contact:
            return "contact"
        case .linkPreview:
            return "linkPreview"
        case .custom:
            return "custom"
        }
    }
}

extension Message {
    
    static func toDictionary(message: Message, receiverId: String) -> [String: Any]{
        var text = ""
        
        switch message.kind {
        case .text(let messageText):
            text = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        return [
            "id": message.messageId,
            "type": message.kind.rawValue,
            "content": text,
            "receiver_id": receiverId,
            "sender_id": message.sender.senderId,
            "date": Int(message.sentDate.timeIntervalSince1970),
            "is_read": false
            
        ]
    }
}
