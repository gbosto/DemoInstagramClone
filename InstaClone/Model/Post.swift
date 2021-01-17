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

        self.caption = dictionary["caption"] as? String ?? " "
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? " "
        self.ownerUid = dictionary["ownerUid"] as? String ?? " "
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.imageUid = dictionary["imageUid"] as? String ?? " "
    }
}
