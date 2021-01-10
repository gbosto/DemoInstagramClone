//
//  UserService.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//


import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {

        API.collectionUsers.document(uid).getDocument { snapshot, error in
            guard let userData = snapshot?.data() else {return}
            let user = User(dictionary: userData)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        API.collectionUsers.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {return}
            
            let users = snapshot.documents.map {User(dictionary: $0.data()) }
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        API.collectionFollowing.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            API.collectionFollowers.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        API.collectionFollowing.document(currentUid).collection("user-following").document(uid).delete { error in
            API.collectionFollowers.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion : @escaping(Bool)-> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        API.collectionFollowing.document(currentUid).collection("user-following").document(uid)
            .getDocument {snapshot, error  in
                guard let isFollowed = snapshot?.exists else {return}
                completion(isFollowed)
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        API.collectionFollowers.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            let followers = snapshot?.documents.count ?? 0
            
            API.collectionFollowing.document(uid).collection("user-following").getDocuments { snapshot, _ in
                let following = snapshot?.documents.count ?? 0
                
                API.collectionPosts.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, _ in
                    let posts = snapshot?.documents.count ?? 0
                    
                    completion(UserStats(followers: followers, following: following, posts: posts))

                }
            }
        }
    }
}
