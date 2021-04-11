//
//  AuthManager.swift
//  Messenger
//
//  Created by user on 10/04/2021.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = FirebaseAuth.Auth.auth()
    
    private init() {}
    
    private enum ApiError: Error {
        case FailedToCreateAccount
    }
    
    public var currentUser: User{
        return user!
    }
    
    public var isSignedIn: Bool {
        return user != nil
    }
    
    private var user: User? {
        return FirebaseAuth.Auth.auth().currentUser
    }
    
    /// create account for the user
    public func createAccount(email: String, password: String, completion: @escaping ((Result<User, Error>)) -> Void){
        auth.createUser(withEmail: email, password: password) { (result, error) in
            DispatchQueue.main.async {
                if let user = result?.user {
                    completion(.success(user))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(ApiError.FailedToCreateAccount))
                }
            }
        }
    }
    
    /// sign in to the app with email and password 
    public func signIn(email: String, password: String, completion: @escaping ((Result<User, Error>)) -> Void){
        auth.signIn(withEmail: email, password: password) { (result, error) in
            DispatchQueue.main.async {
                if let user = result?.user {
                    completion(.success(user))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(ApiError.FailedToCreateAccount))
                }
            }
        }
    }
    
    public func signOut(completion: (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
