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
        self.text = dictionary[Resources.text] as? String ?? Resources.emptyString
        self.toId = dictionary[Resources.toId] as? String ?? Resources.emptyString
        self.fromId = dictionary[Resources.fromId] as? String ?? Resources.emptyString
        self.timestamp = dictionary[Resources.timestamp] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
