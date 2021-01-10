//
//  CommentsService.swift
//  InstaClone
//
//  Created by Giorgi on 1/6/21.
//

import Firebase

struct CommentService {
    static func uploadComments(comment: String, postID: String, user: User,
                               completion: @escaping(FirestoreCompletion)) {
        
        let data: [String:Any] = ["uid" : user.uid,
                                   "comment" : comment,
                                   "timestamp" : Timestamp(date: Date()),
                                   "username" : user.username,
                                   "profileImageUrl" : user.profileImageUrl]
        
        API.collectionPosts.document(postID).collection("comments").addDocument(data: data, completion: completion)
        
    }
    
    static func fetchComments (forPost postID: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        let query = API.collectionPosts.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
    }
}
