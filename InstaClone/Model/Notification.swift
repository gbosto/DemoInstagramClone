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
    
    var userIsFollowed = false
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
