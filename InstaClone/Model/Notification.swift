//
//  Notification.swift
//  InstaClone
//
//  Created by Giorgi on 1/8/21.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like:
            return " liked your post."
        case .follow:
            return " started following you."
        case .comment:
            return " commented on your post"
        }
    }
}

struct Notification {
    let uid: String
    let id: String
    var postId: String?
    let postImageUrl: String?
    let type: NotificationType
    let timestamp: Timestamp
    let toUid: String
    
    var userIsFollowed = false
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary[Resources.uid] as? String ?? Resources.emptyString
        self.id = dictionary[Resources.id] as? String ?? Resources.emptyString
        self.toUid = dictionary[Resources.toUid ] as? String ?? Resources.emptyString
        self.postId = dictionary[Resources.postId] as? String ?? Resources.emptyString
        self.postImageUrl = dictionary[Resources.postImageUrl] as? String ?? Resources.emptyString
        self.type = NotificationType(rawValue: dictionary[Resources.type] as? Int ?? 0) ?? .like
        self.timestamp = dictionary[Resources.timestamp] as? Timestamp ?? Timestamp(date: Date())
    }
}
