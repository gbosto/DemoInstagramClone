//
//  AuthService.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase





struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String,
                          completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials,
                             completion: @escaping(FirestoreCompletion)) {
        let uuid = NSUUID().uuidString
        let directoryName = FireStoreDirectory.profileImages
        
        ImageService.uploadImage(image: credentials.profileImage, uuid: uuid, directory: directoryName) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email,
                                   password: credentials.password) { result, error in
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                    }
                
                guard let uid = result?.user.uid else {return}
                
                let data: [String : Any] = [ Resources.email : credentials.email,
                                             Resources.fullname : credentials.fullname,
                                             Resources.profileImageUrl : imageUrl,
                                             Resources.uid : uid,
                                             Resources.username : credentials.username,
                                             Resources.profileImageUid : uuid]
                
                    API.collectionUsers.document("\(uid)").setData(data, completion: completion)
            }
        }
    }
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
