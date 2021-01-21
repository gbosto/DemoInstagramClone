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
        self.email = dictionary[Resources.email] as? String ?? Resources.emptyString
        self.fullname = dictionary[Resources.fullname] as? String ?? Resources.emptyString
        self.profileImageUrl = dictionary[Resources.profileImageUrl ] as? String ?? Resources.emptyString
        self.username = dictionary[Resources.username] as? String ?? Resources.emptyString
        self.uid = dictionary[Resources.uid] as? String ?? Resources.emptyString
        self.profileImageUid = dictionary[Resources.profileImageUid] as? String ?? Resources.emptyString

        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}
