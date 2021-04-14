//
//  ChatViewController.swift
//  Messenger
//
//  Created by user on 14/04/2021.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {
    
    private var messages: [Message] = []
    
    private let sender = Sender(photoURL: "", senderId: "1", displayName: "Annulus")
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: sender, messageId: "123", sentDate: Date(), kind: .text("Hi Gbemi!. How are you doing?")))
        messages.append(Message(sender: sender, messageId: "123", sentDate: Date(), kind: .text("Call me when you see this message")))
        configureUI()
    }
    
    // MARK: Methods
    
    private func configureUI(){
        view.backgroundColor = .systemBackground
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        showMessageTimestampOnSwipeLeft = true
    }
}

// MARK: Message
extension ChatViewController: MessagesDisplayDelegate, MessagesDataSource, MessagesLayoutDelegate {
    
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
   
}
