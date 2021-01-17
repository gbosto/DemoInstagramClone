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
        self.uid = dictionary["uid"] as? String ?? ""
        self.comment = dictionary["comment"] as? String ?? ""
        self.commentId = dictionary["commentId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
