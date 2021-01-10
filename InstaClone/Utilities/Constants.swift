//
//  Constants.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase

struct ReuseId {
    static let forFeedCell = "FeedCell"
    static let forProfileCell = "ProfileCell"
    static let forProfileHeader = "ProfileHeader"
    static let forSearchTableViewCell = "SearchCellTV"
    static let forSearchCollectionViewCell = "SearchCellCV"
    static let forCommentCell = "CommentsCell"
    static let forNotificationsCell = "NotificationsCell"
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
}
