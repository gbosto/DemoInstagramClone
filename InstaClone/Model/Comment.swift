//
//  Comment.swift
//  InstaClone
//
//  Created by Giorgi on 1/6/21.
//

import Firebase

struct Comment {
    let uid: String
    let comment: String
    let commentId: String
    let timestamp: Timestamp
    
    var commentBelongsToCurrentUser = false
    var postBelongsToCurrentUser = false
    
    init(dictionary: [String:Any]) {
        self.uid = dictionary[Resources.uid] as? String ?? Resources.emptyString
        self.comment = dictionary[Resources.comment] as? String ?? Resources.emptyString
        self.commentId = dictionary[Resources.commentId] as? String ?? Resources.emptyString
        self.timestamp = dictionary[Resources.timestamp] as? Timestamp ?? Timestamp(date: Date())
    }
}
