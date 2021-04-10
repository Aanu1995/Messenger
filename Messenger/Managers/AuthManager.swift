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
    
    private init() {}
    
    private enum ApiError: Error {
        case FailedToCreateAccount
    }
    
    public var isSignedIn: Bool {
        return false
    }
    
    public func createAccount(email: String, password: String, completion: @escaping ((Result<User, Error>)) -> Void){
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
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
    
    public func signIn(email: String, password: String, completion: @escaping ((Result<User, Error>)) -> Void){
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
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
}
