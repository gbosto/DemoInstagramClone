//
//  Post.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase

struct Post {
    let postId: String
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let imageUid: String

    var didLike = false
    var belongsToCurrentUser = false
    
    init(postId: String, dictionary: [String : Any]) {
        self.postId = postId

        self.caption = dictionary[Resources.caption] as? String ?? Resources.emptyString
        self.likes = dictionary[Resources.likes] as? Int ?? 0
        self.imageUrl = dictionary[Resources.imageUrl] as? String ?? Resources.emptyString
        self.ownerUid = dictionary[Resources.ownerUid] as? String ?? Resources.emptyString
        self.timestamp = dictionary[Resources.timestamp] as? Timestamp ?? Timestamp(date: Date())
        self.imageUid = dictionary[Resources.imageUid] as? String ?? Resources.emptyString
    }
}
