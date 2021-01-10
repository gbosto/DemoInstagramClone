//
//  ImageUploader.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(image: UIImage,
                            competion: @escaping(String)-> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let fileName = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
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
}

