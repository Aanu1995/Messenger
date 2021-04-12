//
//  AuthManager.swift
//  Messenger
//
//  Created by user on 10/04/2021.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

final class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = FirebaseAuth.Auth.auth()
    private let database = Database.database().reference();
    
    private init() {}
    
    // this variables is only used when signing via Google
    public var googleSignInCredential: AuthCredential?
    public var gidUser: GIDGoogleUser?
    
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
    
    /// sign in to the app with email and password
    public func signInWithCredential(credential: AuthCredential, completion: @escaping ((Result<User, Error>)) -> Void){
        auth.signIn(with: credential) { (result, error) in
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
    
    public func getCurrentUser(userId: String, completion: @escaping (Result<ChatAppUser, Error>) -> Void){
        database.child(Constants.Accounts.users).child(userId).getData { (error, snapshot) in
            if let error = error {
                completion(Result.failure(error))
                return
            }
        }
    }
    
    /// sign user out of the app
    public func signOut(completion: (Error?) -> Void) {
        do {
            try auth.signOut()
            GIDSignIn.sharedInstance()?.signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
