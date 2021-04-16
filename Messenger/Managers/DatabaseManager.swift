//
//  DatabaseManager.swift
//  Messenger
//
//  Created by user on 11/04/2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    private let database = Database.database().reference();
    
    // get all users in the database
    public func getAllUsers(completion: @escaping (Result<[ChatAppUser], Error>) -> Void){
        database.child(Constants.Database.users).getData { (error, dataSnapshot) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            var users: [ChatAppUser] = []
           
            for child in dataSnapshot.children {
                let snap = child as! DataSnapshot
                if let value = snap.value as? [String: Any] {
                    do{
                        let data = try JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed)
                        let user = try JSONDecoder().decode(ChatAppUser.self, from: data)
                        if user.uid != AuthManager.shared.currentUser.uid {
                            users.append(user)
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                   
                }
            }
            completion(.success(users))
        }
    }
    
}

// MARK: - User Account Management

extension DatabaseManager {
    
    /// checks if new user already exists
    private func isUserExists (with uid: String, completion: @escaping (Bool) -> Void) {
        database.child(Constants.Database.users).child(uid).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // add user data to database
    public func insertUser (user: ChatAppUser, image: Data?, completion: @escaping () -> Void) {
        isUserExists(with: user.uid) { [weak self] success in
            
            guard let strongSelf = self else { return }
            
            if !success {
                guard let image = image else {
                    strongSelf.addUserDataToDatabase(user: user)
                    completion()
                    return
                }
                
                // upload image
                StorageManager.shared.uploadProfilePicture(with: image, fileName: user.uid + ".png") { result in
                    var profileURL: String
                    switch result{
                    case .success(let imageURL):
                        profileURL = imageURL
                    case .failure:
                        profileURL = ""
                    }
                    
                    let newUser = ChatAppUser(uid: user.uid, firstName: user.firstName, lastName: user.lastName, email: user.email, photoURL: profileURL)
                    
                    strongSelf.addUserDataToDatabase(user: newUser)
                    completion()
                }
               
            }
        }
    }
    
    private func addUserDataToDatabase(user: ChatAppUser){
        let data = try! JSONSerialization.jsonObject(with: try! JSONEncoder().encode(user), options: .fragmentsAllowed)
        self.database.child(Constants.Database.users).child(user.uid).setValue(data)
    }
}

// MARK: All conversations and Messages

extension DatabaseManager {
    
    /// create new conversation by sending the first message
    public func createNewConversation(with otherUser: ChatAppUser, conversationId: String, message: Message, completion: @escaping(Bool) -> Void) {
        
        

    }
    
    /// get all list of conversations that the current user has had with other users
    public func getAllConversations(for user: ChatAppUser, completion: @escaping (Result<[Conversation], Error>) -> Void){
        database.child(Constants.Database.conversations).getData { (error, snapshot) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            var chats: [Conversation] = []
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                if let value = snap.value as? [String: Any], (value["id"] as! String).contains(user.uid) {
                    let data = try! JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed)
                    let chat = try! JSONDecoder().decode(Conversation.self, from: data)
                    chats.append(chat)
                }
            }
            completion(.success(chats))
        }
    }
    
    /// get all messages for a conversation with othe ruser
    public func getAllMessagesForConversation(with receiver: ChatAppUser, completion: @escaping () -> Void){
        
    }
    
    /// append message to already existing messages for conversation with other user
    public func sendMessage(with otherUser: ChatAppUser, conversationId: String, message: Message, completion: @escaping(Bool) -> Void) {
        let conversationDictionary = Conversation.toDictionary(conversationId: conversationId, message: message, receiverId: otherUser.uid)
        database.child(Constants.Database.conversations).child(conversationId).setValue(conversationDictionary) { [weak self] (error, _) in
            if error == nil {
                let messageDictionary = Message.toDictionary(message: message, receiverId: otherUser.uid)
                guard let strongSelf = self else { return }
                strongSelf.database.child(Constants.Database.messages).child(conversationId).child(message.messageId).setValue(messageDictionary)
                completion(true)
               return
            }
            completion(false)
        }
    }
}
