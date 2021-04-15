//
//  StorageManager.swift
//  Messenger
//
//  Created by user on 15/04/2021.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = FirebaseStorage.Storage.storage().reference()
    
    private enum StorageError: Error {
        case failedToUploadError
    }
    
    // upload profile picture to firebase storage with a compltion that returns image url string or Error
    typealias uploadPictureCompltion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping uploadPictureCompltion) {
        storage.child("profiles").child(fileName).putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(.failure(StorageError.failedToUploadError))
                return
            }
            
            self.storage.child("profiles").child(fileName).downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(StorageError.failedToUploadError))
                    return
                }
                
                completion(.success(url.absoluteString))
            }
        }
    }
}
