//
//  NotificationViewModel.swift
//  InstaClone
//
//  Created by Giorgi on 1/8/21.
//

import UIKit

struct NotificationViewModel {
    var notification: Notification
    var user: User
    
    init(notification: Notification, user: User) {
        self.notification = notification
        self.user = user
    }
    
    var postImageUrl: URL? {
        return URL(string: notification.postImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    private var timestampString: String? {
        let formater = DateComponentsFormatter()
        formater.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formater.maximumUnitCount = 1
        formater.unitsStyle = .abbreviated
        
        return formater.string(from: notification.timestamp.dateValue(), to: Date())
    }
    
    var notificationMessage: NSAttributedString {
        let username = user.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " \(timestampString ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                                             .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHidePostImage: Bool {
        return notification.type == .follow
    }
    
    var followButtonText: String {
        return notification.userIsFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.userIsFollowed ? .black : .white
    }
}
