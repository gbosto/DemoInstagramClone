//
//  NotificationService.swift
//  InstaClone
//
//  Created by Giorgi on 1/8/21.
//

import Firebase



struct NotificationService {
    static func uploadNotification(toUid uid: String,
                                   fromUser: User,
                                   type: NotificationType,
                                   post: Post? = nil) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard uid != currentUid else {return}
        
        let docRef = API.collectionNotifications.document(uid).collection(Resources.userNotifications).document()
        
        var data: [String: Any] = [Resources.timestamp : Timestamp(date: Date()),
                                   Resources.uid : fromUser.uid,
                                   Resources.type : type.rawValue,
                                   Resources.id : docRef.documentID]
        
        if let post = post {
            data[Resources.postId] = post.postId
            data[Resources.postImageUrl] = post.imageUrl
        }
        
            docRef.setData(data)
    }
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
                
        API.collectionNotifications.document(uid).collection(Resources.userNotifications).order(by: Resources.timestamp,
                                                                                                descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            
            let notifications = documents.map { Notification(dictionary: $0.data())}
            completion(notifications)
        }
    }
    
    static func checkIfPostStillExists(postId: String, completion: @escaping(Bool) -> Void){
        
        API.collectionPosts.document(postId).getDocument { snapshot, error in
            guard let postExists = snapshot?.exists else {return}
            completion(postExists)
        }
    }
}

