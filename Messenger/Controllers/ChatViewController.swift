//
//  ChatViewController.swift
//  Messenger
//
//  Created by user on 14/04/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    // MARK: Instance Variables
    
    private let receiverUser: ChatAppUser
    private let senderUser: ChatAppUser
    private let conversationId: String
    
    init(receiver: ChatAppUser, sender: ChatAppUser, id: String?) {
        if let id = id{
            self.conversationId = id
        } else {
            self.conversationId = sender.uid + "_" + receiver.uid
        }
        self.receiverUser = receiver
        self.senderUser = sender
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    
    private var messages: [Message] = []
    private var sender: Sender!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sender = Sender(photoURL: senderUser.photoURL, senderId: senderUser.email, displayName: senderUser.fullName)
        configureTitleHeader()
        configureUI()
    }
    
    // MARK: Methods
    
    private func configureTitleHeader() {
        let titleView = TitleView()
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        titleView.configure(with: UserViewModel(fullName: receiverUser.fullName, photoURL: receiverUser.imageURL))
        navigationItem.titleView = titleView
    }
    
    private func configureUI(){
        view.backgroundColor = .systemBackground
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        // configure text input
        messageInputBar.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        messagesCollectionView.addGestureRecognizer(gesture)
        
       
       
    }
    
    @objc func closeKeyboard(){
        print("Hello")
        messageInputBar.resignFirstResponder()
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        let messageId = UUID().uuidString
        let message = Message(sender: sender, messageId: messageId, sentDate: Date(), kind: .text(text))
        DatabaseManager.shared.sendMessage(with: receiverUser, conversationId: conversationId, message: message) { success in
            inputBar.inputTextView.text = ""
        }
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
