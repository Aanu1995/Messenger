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
    
}

// MARK: - User Account Management

extension DatabaseManager {
    
    /// checks if new user already exists
    private func isUserExists (with uid: String, completion: @escaping (Bool) -> Void) {
        database.child(Constants.Accounts.users).child(uid).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // add user data to database
    public func insertUser (user: ChatAppUser, completion: @escaping () -> Void) {
        isUserExists(with: user.uid) { [weak self] success in
            if !success {
                let data = try! JSONSerialization.jsonObject(with: try! JSONEncoder().encode(user), options: .fragmentsAllowed)
                print(data)
                self?.database.child(Constants.Accounts.users).child(user.uid).setValue(data)
            }
            completion()
        }
    }
}
