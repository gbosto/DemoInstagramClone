//
//  Message.swift
//  InstaClone
//
//  Created by Giorgi on 1/15/21.
//

import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId:String
    var timestamp: Timestamp!
    let isFromCurrentUser: Bool
    
    var user: User?
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toId : fromId
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
