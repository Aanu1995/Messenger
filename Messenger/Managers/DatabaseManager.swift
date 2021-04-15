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
