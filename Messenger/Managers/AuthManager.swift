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
        case FailedToLogin
    }
    
    private var user: ChatAppUser?
    
    public var currentUser: ChatAppUser {
        return user!
    }
    
    public var isSignedIn: Bool {
        return user != nil
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
    public func signIn(email: String, password: String, completion: @escaping (Error?) -> Void){
        auth.signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let user = result?.user {
                guard let strongSelf = self else {
                    completion(ApiError.FailedToCreateAccount)
                    return
                }
                strongSelf.getCurrentUser(userId: user.uid) { (result) in
                    completion(nil)
                }
            } else if let error = error {
                completion(error)
            } else {
                completion(ApiError.FailedToCreateAccount)
            }
        }
    }
    
    /// sign in to the app with credential
    public func signInWithCredential(credential: AuthCredential, completion: @escaping ((Result<User, Error>)) -> Void){
        auth.signIn(with: credential) { (result, error) in
            if let user = result?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(ApiError.FailedToCreateAccount))
            }
        }
    }
    
    public func getCurrentUser(userId: String, completion: @escaping (Error?) -> Void){
        database.child(Constants.Database.users).child(userId).getData { [weak self] (error, snapshot) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let strongSelf = self, let value = snapshot.value as? [String: Any] else {
                completion(ApiError.FailedToLogin)
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed)
                strongSelf.cacheUserData(data: data)
                strongSelf.getUserDataFromCache()
                completion(nil)
            }catch {
                completion(ApiError.FailedToLogin)
            }
        }
    }
    
    // save user data to local storage
    private func cacheUserData(data: Data){
        UserDefaults.standard.setValue(data, forKey: Constants.Accounts.user)
    }
    
    // retrieve user data from storage
    public func getUserDataFromCache(){
        do {
            guard let data = UserDefaults.standard.data(forKey: Constants.Accounts.user) else {
                user = nil
                return
            }
            let chatUser = try JSONDecoder().decode(ChatAppUser.self, from: data)
            user = chatUser
        }catch{
            user = nil
        }
    }
    
    /// sign user out of the app
    public func signOut(completion: (Error?) -> Void) {
        do {
            try auth.signOut()
            GIDSignIn.sharedInstance()?.signOut()
            UserDefaults.standard.setValue(nil, forKey: Constants.Accounts.user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
