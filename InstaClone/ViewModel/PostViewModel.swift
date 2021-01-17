//
//  PostViewModel.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

struct PostViewModel {
    var post: Post
    var user: User?
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var caption: String {
        return post.caption
    }
    
    var likesButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likesButtonImage: UIImage {
        return post.didLike ?  #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
    }
    
    var likes: String {
        if post.likes == 0 {
            return "be first who likes this post"
        } else if post.likes == 1 {
            return "\(post.likes) like"
        } else {
            return "\(post.likes) likes"
        }
    }
    
    var userProfileImageUrl: URL? {
        guard let user = user else {return URL(string: "")}
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        guard let user = user else {return ""}
        return user.username
    }
    
    var detailsButtonIsHidden: Bool {
        return post.belongsToCurrentUser
    }
    
     var timestampString: String? {
        let formater = DateComponentsFormatter()
        formater.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formater.maximumUnitCount = 1
        formater.unitsStyle = .full
        
        return formater.string(from: post.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    init(post: Post, user: User? = nil) {
        self.post = post
        self.user = user
    }
}
