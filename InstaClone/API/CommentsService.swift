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
        
        let docRef = API.collectionPosts.document(postID).collection(Resources.comments).document()
        
        let data: [String:Any] = [  Resources.uid : user.uid,
                                    Resources.comment : comment,
                                    Resources.timestamp : Timestamp(date: Date()),
                                    Resources.username : user.username,
                                    Resources.profileImageUrl : user.profileImageUrl,
                                    Resources.commentId : docRef.documentID]
        
        docRef.setData(data, completion: completion)
    }
    
    static func fetchComments (forPost postID: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        let query = API.collectionPosts.document(postID).collection(Resources.comments).order(by: Resources.timestamp, descending: true)
        
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
    
    static func checkIfCommentBelongsToCurrentUser(post: Post, comment: Comment, completion: @escaping(Bool) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        var belongsTo = false
    
        if comment.uid == currentUserUid {
            belongsTo = true
        }
        completion(belongsTo)
    }
    
    static func deleteComment(forPost post: Post, comment: Comment) {
        API.collectionPosts.document(post.postId).collection(Resources.comments).document(comment.commentId).delete()
    }
}
