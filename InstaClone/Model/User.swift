//
//  Usetr.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    let profileImageUid: String
    
    var isFollowed = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String : Any]) {
        self.email = dictionary["email"] as? String ?? " "
        self.fullname = dictionary["fullname"] as? String ?? " "
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? " "
        self.username = dictionary["username"] as? String ?? " "
        self.uid = dictionary["uid"] as? String ?? " "
        self.profileImageUid = dictionary["profileImageUid"] as? String ?? " "

        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}
