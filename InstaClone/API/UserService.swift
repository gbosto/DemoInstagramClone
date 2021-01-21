//
//  UserService.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//


import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    
    static func fetchCurrentUser(completion: @escaping(User) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        fetchUser(withUid: currentUserUid) { user in
            completion(user)
        }
    }
    
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
        API.collectionFollowing.document(currentUid).collection(Resources.userFollowing).document(uid).setData([:]) { error in
            API.collectionFollowers.document(uid).collection(Resources.userFollowers).document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        API.collectionFollowing.document(currentUid).collection(Resources.userFollowing).document(uid).delete { error in
            API.collectionFollowers.document(uid).collection(Resources.userFollowers).document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion : @escaping(Bool)-> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        API.collectionFollowing.document(currentUid).collection(Resources.userFollowing).document(uid)
            .getDocument {snapshot, error  in
                guard let isFollowed = snapshot?.exists else {return}
                completion(isFollowed)
        }
    }

    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        API.collectionFollowers.document(uid).collection(Resources.userFollowers).getDocuments { snapshot, _ in
            let followers = snapshot?.documents.count ?? 0
            
            API.collectionFollowing.document(uid).collection(Resources.userFollowing).getDocuments { snapshot, _ in
                let following = snapshot?.documents.count ?? 0
                
                API.collectionPosts.whereField(Resources.ownerUid, isEqualTo: uid).getDocuments { snapshot, _ in
                    let posts = snapshot?.documents.count ?? 0
                    
                    completion(UserStats(followers: followers, following: following, posts: posts))

                }
            }
        }
    }
    
    static func fetchFollowers(forUid uid: String, completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        API.collectionFollowers.document(uid).collection(Resources.userFollowers).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            documents.forEach { document in
                UserService.fetchUser(withUid: document.documentID) { user in
                    users.append(user)
                    completion(users)
                }
            }
        }
    }
    
    static func fetchFollowing(forUid uid: String, completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        API.collectionFollowing.document(uid).collection(Resources.userFollowing).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            documents.forEach { document in
                UserService.fetchUser(withUid: document.documentID) { user in
                    users.append(user)
                    completion(users)
                }
            }
        }
    }
  
    static func changeUser(user: User, name: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        
        API.collectionUsers.document(currentUserUid).updateData([Resources.fullname: name])
    }
    
    static func changeUser(user: User, username: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        
        API.collectionUsers.document(currentUserUid).updateData([Resources.username: username])
    }
    
    static func changeUsersProfileImageUrl(user: User, url: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        
        API.collectionUsers.document(currentUserUid).updateData([Resources.profileImageUrl: url])
    }
}
