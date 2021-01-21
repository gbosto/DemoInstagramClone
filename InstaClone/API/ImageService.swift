//
//  ImageUploader.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import FirebaseStorage

struct ImageService {
    
    static func uploadImage(image: UIImage, uuid: String, directory: String,
                            competion: @escaping(String)-> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let reference = Storage.storage().reference(withPath: "\(directory)\(uuid)")
        
        reference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
                }
            
            reference.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {return}
                competion(imageUrl)
            }
        }
    }
    
    static func deleteImage(withUid uuid: String, directory: String, completion: @escaping(FirestoreCompletion)) {
        
        let reference = Storage.storage().reference(withPath: "\(directory)\(uuid)")
        
        reference.delete(completion: completion)
    }
}

