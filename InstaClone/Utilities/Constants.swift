//
//  Constants.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase

struct FireStoreDirectory {
    static let posts = "/posts/"
    static let profileImages = "/profile_images/"
}

struct NavigationItemTitle {
    static let forFeedController = "Feed"
    static let forUploadPost = "Upload Post"
}

struct API {
    static let collectionUsers = Firestore.firestore().collection("users")
    static let collectionFollowers = Firestore.firestore().collection("followers")
    static let collectionFollowing = Firestore.firestore().collection("following")
    static let collectionPosts = Firestore.firestore().collection("posts")
    static let collectionNotifications = Firestore.firestore().collection("notifications")
    static let collectionMessages = Firestore.firestore().collection("messages")
}

struct Resources {
    static let email = "email"
    static let fullname = "fullname"
    static let profileImageUrl = "profileImageUrl"
    static let uid = "uid"
    static let username = "username"
    static let profileImageUid = "profileImageUid"
    
    static let userFollowing = "user-following"
    static let userFollowers = "user-followers"
    
    static let caption = "caption"
    static let timestamp = "timestamp"
    static let likes = "likes"
    static let imageUrl = "imageUrl"
    static let ownerUid = "ownerUid"
    static let imageUid = "imageUid"
    
    static let postLikes = "post-likes"
    static let userLikes = "user-likes"
    static let userFeed = "user-feed"
    
    static let comment = "comment"
    static let commentId = "commentId"
    
    static let comments = "comments"
    
    static let userNotifications = "user-notifications"
    
    static let type = "type"
    static let id = "id"
    static let postId = "postId"
    static let postImageUrl = "postImageUrl"
    
    static let text = "text"
    static let fromId = "fromId"
    static let toId = "toId"
    
    static let recentMessages = "recent-messages"
    static let emptyString = " "
    
    static let toUid = "toUid"
}
