//
//  Conversation.swift
//  Messenger
//
//  Created by user on 16/04/2021.
//

import Foundation

struct Conversation: Codable {
    let id: String
    let lastMessage: LastMessage
    let receiverId: String
    
    struct LastMessage: Codable {
        let date: Int
        let isRead: Bool
        let message: String
        
        enum CodingKeys: String, CodingKey {
            case date
            case isRead = "is_read"
            case message
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case lastMessage = "latest_message"
        case receiverId = "receiver_id"
    }
}


extension Conversation {
    var dateInDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(lastMessage.date))
    }
    
    static func toDictionary(conversationId: String, message: Message, receiverId: String) -> [String: Any]{
        
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
            "id":conversationId,
            "receiver_id": receiverId,
            "latest_message": [
                "date": Int(message.sentDate.timeIntervalSince1970),
                "message": text,
                "is_read": false
            ]
        ]
    }
}
