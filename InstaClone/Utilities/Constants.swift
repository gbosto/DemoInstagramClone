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
