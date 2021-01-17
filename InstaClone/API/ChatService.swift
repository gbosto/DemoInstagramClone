//
//  ChatService.swift
//  InstaClone
//
//  Created by Giorgi on 1/15/21.
//

import Firebase

struct ChatService {

    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text" : message,
                    "fromId" : currentUid,
                    "toId" : user.uid,
                    "timestamp" : Timestamp(date: Date())] as [String : Any]
        
        API.collectionMessages.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            API.collectionMessages.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
        }
        
        API.collectionMessages.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
        
        API.collectionMessages.document(user.uid).collection("recent-messages").document(currentUid).setData(data)

    }
    
    static func fetchMessages(forUser user: User, completion: @escaping ([Message]) -> Void) {
        var messages = [Message]()
        
        guard  let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = API.collectionMessages.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                let dictionary = change.document.data()
                messages.append(Message(dictionary: dictionary))
                completion(messages)
                }
            })
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = API.collectionMessages.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dict = change.document.data()
                let message = Message(dictionary: dict)
                
                UserService.fetchUser(withUid: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
}
